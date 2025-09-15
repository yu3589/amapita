module BadgeHelper
  def display_post_badge(user)
    PostBadge.current_post_badge(user)&.name
  end

  def display_sweetness_twin_badge(user)
    badge = SweetnessTwins::Badge.current_twin_badge(user)
    badge&.name
  end

  # current_userから見てuserがツインか？
  def sweetness_twin?(user)
    SweetnessTwin.exists?(user: current_user, twin_user: user)
  end
end
