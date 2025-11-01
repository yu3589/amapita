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
      text_color = "5d5959"
      cache_buster = post.updated_at.to_i

      image_configs = {
        lack_of_sweetness: "v1761961624/lack_of_sweetness_ono0hs.png",
        could_be_sweeter: "v1761961624/lack_of_sweetness_ono0hs.png",
        perfect_sweetness: "v1761961623/perfect_sweetness_x77fs3.png",
        slightly_too_sweet: "v1761961624/slightly_too_sweet_wznrwj.png",
        too_sweet: "v1761961624/too_sweet_jvsjke.png"
      }

      image_path = image_configs[post.sweetness_rating.to_sym]
      return asset_url("ogp.png") unless image_path

      "https://res.cloudinary.com/dbar0jd0k/image/upload/" \
      "l_text:TakaoGothic_40_bold:#{product_text}," \
      "co_rgb:#{text_color},c_fit,g_north,y_65/" \
      "#{image_path}?v=#{cache_buster}"
    rescue => e
      Rails.logger.error "OGP画像生成エラー: #{e.message}"
      asset_url("ogp.png")
    end
  end

  def post_meta_tags(post)
    ogp_image = generate_sweetness_ogp_url(post)
    title = "あまピタッ！"
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

  # 診断結果用
  def diagnosis_meta_tags(profile)
    ogp_image = case profile.sweetness_kind.to_sym
    when :fresh_natural
      "https://res.cloudinary.com/dbar0jd0k/image/upload/v1761990278/fresh_natural_evayip.png"
    when :rich_romantic
      "https://res.cloudinary.com/dbar0jd0k/image/upload/v1761990277/rich_romantic_nfkn1c.png"
    when :sweet_dreamer
      "https://res.cloudinary.com/dbar0jd0k/image/upload/v1761990278/sweet_dreamer_qvgclj.png"
    when :balance_seeker
      "https://res.cloudinary.com/dbar0jd0k/image/upload/v1761990277/balance_seeker_ufeiyg.png"
    else
      image_url("ogp.png")
    end

    title = "あまピタッ！"
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
