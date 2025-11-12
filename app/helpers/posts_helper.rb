module PostsHelper
  def recommend_state(user, recommended_posts)
    return :guest unless user_signed_in?
    return :not_diagnosed unless user.sweetness_profiles.any?

    if user.sweetness_twins.present?
      return :twin_with_posts if recommended_posts.any?
      :twin_without_posts
    else
      :no_twin
    end
  end
end
