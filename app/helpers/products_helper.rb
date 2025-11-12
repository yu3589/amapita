module ProductsHelper
  def show_reputation_button(post, user_unpublish_post, options = {}, &block)
    product = post.product

    unless user_signed_in?
      return content_tag :div, options.merge(
        class: "#{options[:class]} tooltip tooltip-top",
        data: { tip: t("defaults.require_login") }
      ), &block
    end

    return if user_unpublish_post.present?

    return if product.posts.exists?(user_id: current_user.id)

    link_to new_post_path(product_id: product.id), options, &block
  end

  def show_new_post_button?(product)
    return true unless user_signed_in?

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
