class ProductDecorator < Draper::Decorator
  delegate_all

  PRODUCT_VARIANT_OPTIONS = { resize_to_fill: [ 300, 300 ], format: :webp, quality: 75 }.freeze

  def product_image(**options)
    default_classes = "object-cover"
    custom_classes  = options[:class]
    merged_classes  = [ default_classes, custom_classes ].compact.join(" ")

    image_source = if object.image.attached? && object.image.blob.persisted?
      object.image.variant(PRODUCT_VARIANT_OPTIONS)
    elsif object.product_image_url.present?
      object.product_image_url
    else
      "default_image.png"
    end

    h.image_tag(image_source, options.merge(class: merged_classes))
  end
end
