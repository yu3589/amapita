module ApplicationHelper
  include Pagy::Frontend

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
