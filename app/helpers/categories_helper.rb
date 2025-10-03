module CategoriesHelper
  def product_link_or_tooltip(category, product, options = {}, &block)
    if user_signed_in?
        link_to category_product_path(category, product), options, &block
    else
        content_tag :div, options.merge(
        class: "#{options[:class]} tooltip tooltip-top",
        data: { tip: t("defaults.require_login") }
        ), &block
    end
  end

  def new_product_link_or_tooltip(options = {}, &block)
    if user_signed_in?
      link_to new_post_path, options, &block
    else
      content_tag :div, options.merge(
        class: "#{options[:class]} tooltip tooltip-top",
        data: { tip: t("defaults.require_login_user_rating") }
      ), &block
    end
  end
end
