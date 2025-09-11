module BadgeHelper
  def display_post_badge(user)
    badge = BadgeService.current_post_badge(user)
    badge&.name  # nil(投稿バッジがない)場合は何も返さない
  end
end
