module SweetnessTwins
  class Matcher
    ATTRIBUTES = %i[sweetness_strength aftertaste_clarity natural_sweetness coolness richness]
    TWIN_TOTAL_SCORE_THRESHOLD = 4

    def self.find_twins_for(profile)
      # 各ユーザーごとに最新のSweetnessProfileのIDを取得
      latest_profile_ids = SweetnessProfile
        .select("MAX(id) as id")
        .where.not(user_id: profile.user_id)
        .group(:user_id)
        .map(&:id)

      # 必須条件
      candidate_profiles = SweetnessProfile
        .includes(:user)
        .where(id: latest_profile_ids)
        .near_sweetness_strength(profile.sweetness_strength, SweetnessProfile::TWIN_MATCH_RANGE)
        .near_aftertaste_clarity(profile.aftertaste_clarity, SweetnessProfile::TWIN_MATCH_RANGE)

      # 総合スコアとの比較
      twin_profiles = candidate_profiles.select do |latest_profile|
        total_score = ATTRIBUTES.sum do |attr|
          (profile.public_send(attr) - latest_profile.public_send(attr)).abs
        end
        total_score <= TWIN_TOTAL_SCORE_THRESHOLD
      end
      twin_profiles.map(&:user).uniq
    end
  end
end
