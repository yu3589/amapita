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

  def show_new_post_button?(product)
    return false unless user_signed_in?

    !product.posts.exists?(user_id: current_user.id)
  end

  # カテゴリ一覧
  # category: slug
  # name: メインラベル
  # subname: サブラベル
  def category_card(category:, name:, subname: nil, extra_class: "")
    link_to category_path(category), class: "flex flex-col items-center justify-center leading-none #{extra_class}" do
      content_tag :div, class: "aspect-square w-30 md:w-40 relative hover-animation",
                        x_data: "{ imageLoaded: false }",
                        x_init: "imageLoaded = $el.querySelector('img')?.complete || false" do
        # ローディング
        concat content_tag(:div, "", class: "absolute inset-0 rounded-3xl bg-base-100 animate-pulse", x_cloak: true, x_show: "!imageLoaded")
        # 画像
        concat image_tag("category/#{category}.webp",
                         class: "category-image w-full h-full object-cover rounded-3xl",
                         "@load": "imageLoaded = true",
                         "@error": "imageLoaded = true")
        # 黒オーバーレイ
        concat content_tag(:div, "", class: "absolute inset-0 bg-black/30 rounded-3xl")
        # ラベル
        label_text = subname ? "#{name}・#{subname}" : name
        label_class = subname ? "category-label-multi" : "category-label"
        concat content_tag(:span, label_text, class: label_class)
      end
    end
  end
end
