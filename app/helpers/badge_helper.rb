module BadgeHelper
  def display_post_badge(user)
    badge = PostBadge.current_post_badge(user)
    badge&.name
  end

  def display_sweetness_twin_badge(user)
    badge = SweetnessTwinBadge.current_twin_badge(user)
    badge&.name
  end
end
