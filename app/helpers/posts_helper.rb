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

  def product_detail_link_or_tooltip(product, options = {}, &block)
    if user_signed_in?
      link_to product_path(product), options, &block
    else
      content_tag :div, options.merge(
        class: "#{options[:class]} tooltip tooltip-top",
        data: { tip: t("defaults.require_login") }
      ), &block
    end
  end
end
