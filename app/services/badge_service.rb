class BadgeService
  # 新しい投稿バッジを付与・DB更新
  def self.check_and_award_post_badges(user)
    post_count = user.posts.count
    target_badge = Badge.available_for(user.posts.count).first

    return unless target_badge

    unless user.user_badges.exists?(badge: target_badge)
      user.badges << target_badge
      return target_badge
    end
    nil
  end

  # 現在の投稿バッジを表示
  def self.current_post_badge(user)
    user.badges.post_badges.order(threshold: :desc).first
  end
end
