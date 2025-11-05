module ProductsHelper
  def show_new_post_button?(product)
    return false unless user_signed_in?

    !product.posts.exists?(user_id: current_user.id)
  end

  def show_unpublish_post_link?(user_unpublish_post)
    user_unpublish_post.present?
  end

  # 商品詳細の戻るボタン
  def back_to_list_path(product)
    if request.path.match?(/^\/categories\/[^\/]+\/products\/\d+/)
      category_path(product.category.slug)
    else
      products_path
    end
  end
end
