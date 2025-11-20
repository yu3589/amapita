module ApplicationHelper
  include Pagy::Frontend

  # 共通情報
  def base_meta_info
    {
      site: "あまピタッ！",
      title: "あまピタッ！",
      description: "甘すぎない、物足りなくない。あなたに“ちょうどいい甘さ”の商品が見つかるアプリ"
    }
  end

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
    info = base_meta_info

    {
      site: info[:site],
      title: info[:title],
      reverse: true,
      charset: "utf-8",
      description: info[:description],
      canonical: request.original_url,
      og: {
        site_name: info[:site],
        title: info[:title],
        description: info[:description],
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

  # 投稿OGP
  def post_meta_tags(post)
    info = base_meta_info
    ogp_image = generate_sweetness_ogp_url(post)

    {
      title: info[:title],
      description: info[:description],
      og: {
        title: info[:title],
        description: info[:description],
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

  # 診断OGP
  def diagnosis_meta_tags(profile)
    ogp_image = case profile.sweetness_kind.to_sym
    when :fresh_natural
      "https://res.cloudinary.com/dbar0jd0k/image/upload/v1763108364/fresh_natural_kwdkrr.png"
    when :rich_romantic
      "https://res.cloudinary.com/dbar0jd0k/image/upload/v1763108363/rich_romantic_q9yomb.png"
    when :sweet_dreamer
      "https://res.cloudinary.com/dbar0jd0k/image/upload/v1763108363/sweet_dreamer_pstyvz.png"
    when :balance_seeker
      "https://res.cloudinary.com/dbar0jd0k/image/upload/v1763108363/balance_seeker_ddlftk.png"
    else
      image_url("ogp.png")
    end

    info = base_meta_info

    {
      title: info[:title],
      description: info[:description],
      og: {
        title: info[:title],
        description: info[:description],
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

  def new_product_link_or_tooltip(options = {}, &block)
    if user_signed_in?
      link_to new_post_path, options, &block
    else
      content_tag :div, options.merge(
        class: "#{options[:class]} tooltip tooltip-top",
        data: { tip: t("defaults.require_login") }
      ), &block
    end
  end

  def product_link(category, product, options = {}, &block)
    path =
      if category.present?
        category_product_path(category.slug, product)
      else
        product_path(product)
      end

    link_to path, options, &block
  end
end
