class SweetnessTwinBadge
  # ログインユーザーと関係するツインのバッジを更新
  def self.refresh_for(user)
    return unless user
    badge = Badge.find_by(badge_kind: :sweetness_twin)
    return unless badge

    # ログインユーザーの最新プロフィールを取得
    latest = SweetnessProfile.latest_profile(user.id)
    return unless latest

    # ツイン判定
    twin_users = find_twins_for(latest)
    # バッジ処理
    ActiveRecord::Base.transaction do
      # 既存のツインバッジをすべて削除
      UserBadge.where(badge: badge).delete_all
      # ツインユーザーに新しくバッジを付与
      twin_users.each do |twin_user|
        UserBadge.create!(user: twin_user, badge: badge)
      end
    end
  end

  private

  # ツインユーザー判定
  def self.find_twins_for(profile)
    # 各ユーザーの最新プロフィールIDを取得
    latest_profile_ids = SweetnessProfile
        .select("MAX(id) as id")
        .where.not(user_id: profile.user_id)
        .group(:user_id)
        .map(&:id)
    # 必須条件
    candidate_profiles = SweetnessProfile
        .includes(:user)
        .where(id: latest_profile_ids)
        .near_sweetness_strength(profile.sweetness_strength, 1)
        .near_aftertaste_clarity(profile.aftertaste_clarity, 1)
    # 総合スコアとの比較
    twin_profiles = candidate_profiles.select do |latest_profile|
      # 全5項目の差分を計算
      total_score = (profile.sweetness_strength - latest_profile.sweetness_strength).abs +
                    (profile.aftertaste_clarity - latest_profile.aftertaste_clarity).abs +
                    (profile.natural_sweetness - latest_profile.natural_sweetness).abs +
                    (profile.coolness - latest_profile.coolness).abs +
                    (profile.richness - latest_profile.richness).abs
      total_score <= 4
    end
    twin_users = twin_profiles.map(&:user).uniq
    twin_users.reject { |user| user.id == profile.user_id }
  end

  def self.current_twin_badge(user)
    badge = user.badges.sweetness_twin_badges.first
    return nil unless badge

    # 最新プロフィールを取得
    latest = SweetnessProfile.latest_profile(user.id)
    return nil unless latest

    # ツイン判定（ツインがいる場合のみバッジとして返す）
    twin_users = find_twins_for(latest)
    twin_users.any? ? badge : nil
  end
end
