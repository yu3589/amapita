module ProductsHelper
  def show_new_post_button?(product)
    return false unless user_signed_in?

    !product.posts.exists?(user_id: current_user.id)
  end

  def show_unpublish_post_link?(user_unpublish_post)
    user_unpublish_post.present?
  end
end
