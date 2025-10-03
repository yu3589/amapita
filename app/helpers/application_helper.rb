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
end
