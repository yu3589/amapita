module SweetnessTwins
  class Updater
    def initialize(user)
      @user = user
    end

    def update_twins
      latest_profile = SweetnessProfile.latest_profile(@user.id)
      return unless latest_profile
      begin
        ActiveRecord::Base.transaction do
          cleanup_existing_twins
          create_new_twins(latest_profile)
        end
      rescue StandardError => e
        Rails.logger.error(
          "[SweetnessTwin::Updater] Failed to update twins for user_id=#{@user.id}: #{e.class} #{e.message}"
        )
        nil
      end
    end

    private

    def cleanup_existing_twins
      # 既存の自分のツインを削除
      @user.sweetness_twins.delete_all
      # 相手側が自分をツインとしていたら削除
      SweetnessTwin.where(twin_user_id: @user.id).delete_all
    end

    def create_new_twins(latest_profile)
      twin_users = SweetnessTwins::Matcher.find_twins_for(latest_profile)

      # ツイン関係を双方向に付与（自分→相手、相手→自分）
      twin_users.each do |twin|
        SweetnessTwin.create!(user: @user, twin_user: twin)
        SweetnessTwin.create!(user: twin, twin_user: @user)
      end
    end
  end
end
