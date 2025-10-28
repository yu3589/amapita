module ApplicationHelper
  include Pagy::Frontend

  def user_profile_link_or_tooltip(user, options = {}, &block)
    if user_signed_in?
      link_to user_path(user), options, &block
    else
      content_tag :div, options.merge(
        class: "#{options[:class]} tooltip tooltip-top",
        data: { tip: t("defaults.require_login_user_profile") }
      ), &block
    end
  end

  def default_meta_tags
    {
      site: "あまピタッ！",
      title: "あまピタッ！",
      reverse: true,
      charset: "utf-8",
      description: "甘すぎない、物足りなくない。あなたにぴったりの甘さが見つかるアプリ。",
      canonical: request.original_url,
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: "website",
        url: request.original_url,
        image: image_url("ogp.png"),
        locale: "ja-JP"
      },
        twitter: {
        card: "summary_large_image",
        image: image_url("ogp.png")
      }
    }
  end

  def generate_sweetness_ogp_url(post)
    return asset_url("ogp.png") unless post&.product&.name

    begin
      product_text = URI.encode_www_form_component("「#{post.product.name}」の").gsub("+", "%20")
      text_color = "6a6565"

      image_configs = {
        lack_of_sweetness: "v1761662057/lack_of_sweetness_xgqer9.png",
        could_be_sweeter: "v1761662266/could_be_sweeter_rnls4t.png",
        perfect_sweetness: "v1761662272/perfect_sweetness_rdbdbl.png",
        slightly_too_sweet: "v1761662274/slightly_too_sweet_gp35s8.png",
        too_sweet: "v1761662270/too_sweet_e1q6fp.png"
      }

      image_path = image_configs[post.sweetness_rating.to_sym]
      return asset_url("ogp.png") unless image_path

      "https://res.cloudinary.com/dbar0jd0k/image/upload/" \
      "l_text:TakaoGothic_50_bold:#{product_text}," \
      "co_rgb:#{text_color},c_fit,g_north,y_60/" \
      "#{image_path}"
    rescue => e
      Rails.logger.error "OGP画像生成エラー: #{e.message}"
      asset_url("ogp.png")
    end
  end

  def post_meta_tags(post)
    ogp_image = generate_sweetness_ogp_url(post)
    title = "甘さ評価"
    description = "甘すぎない、物足りなくない。あなたにぴったりの甘さが見つかるアプリ。"

    {
      title: title,
      description: description,
      og: {
        title: title,
        description: description,
        image: ogp_image,
        url: request.original_url,
        type: "article"
      },
      twitter: {
        card: "summary_large_image",
        image: ogp_image
      }
    }
  end
end
