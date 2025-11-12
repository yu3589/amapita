module CategoriesHelper
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
