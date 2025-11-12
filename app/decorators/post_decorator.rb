class PostDecorator < Draper::Decorator
  delegate_all

  POST_VARIANT_OPTIONS = { resize_to_fill: [ 200, 200 ], format: :webp, quality: 75 }.freeze

  def post_image(**options)
    default_classes = "object-cover"
    custom_classes  = options[:class]
    merged_classes  = [ default_classes, custom_classes ].compact.join(" ")

    image_source = if object.image.attached? && object.image.blob.persisted?
      if object.image.blob.content_type == "image/webp"
        object.image
      else
        object.image.variant(POST_VARIANT_OPTIONS)
      end
      object.image.variant(POST_VARIANT_OPTIONS)
    elsif object.product&.image&.attached? && object.product.image.blob.persisted?
      object.product.image.variant(POST_VARIANT_OPTIONS)
    elsif object.product&.product_image_url.present?
      object.product.product_image_url
    else
      "default_image.png"
    end

    h.image_tag(image_source, options.merge(class: merged_classes))
  end
end
