module SweetnessTwins
  class Badge
    def initialize(user)
      @user = user
    end

    def refresh_twin_badges
      badge = ::Badge.find_by(badge_kind: :sweetness_twin)
      return unless badge

      latest_profile = SweetnessProfile.latest_profile(@user.id)
      return unless latest_profile

      begin
        ActiveRecord::Base.transaction do
          update_twin_badges(latest_profile)
        end
      rescue StandardError => e
        Rails.logger.error(
          "[SweetnessTwins::Badge] Failed to refresh twin badges for user_id=#{@user.id}: #{e.class} #{e.message}"
        )
        nil
      end
    end

    # ユーザーに付与されている最新の甘さツインバッジを取得
    def self.current_twin_badge(user)
      user.sweetness_twin_badges.reload.order(threshold: :desc).first
    end

    private

    def update_twin_badges(latest_profile)
      badge = ::Badge.find_by(badge_kind: :sweetness_twin)
      return unless badge
      # ツインユーザーを取得
      twin_users = SweetnessTwins::Matcher.find_twins_for(latest_profile)
      # ユーザーと新しいツインユーザーの古いツインバッジを削除
      UserBadge.where(user_id: [ @user.id ] + twin_users.map(&:id), badge: badge).delete_all
      # 新しいツインユーザーにバッジを付与
      twin_users.each do |twin_user|
        UserBadge.create!(user: twin_user, badge: badge)
      end
    end
  end
end
