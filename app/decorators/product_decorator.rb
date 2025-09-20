class ProductDecorator < Draper::Decorator
  delegate_all

  PRODUCT_VARIANT_OPTIONS = { resize_to_fill: [ 300, 300 ], format: :webp, saver: { quality: 75 } }.freeze

  def product_image(**options)
    default_classes = "object-cover"
    custom_classes  = options[:class]
    merged_classes  = [ default_classes, custom_classes ].compact.join(" ")

    h.image_tag(
      object.image.attached? ? object.image.variant(PRODUCT_VARIANT_OPTIONS) : "default_image.png",
      options.merge(class: merged_classes)
    )
  end
end
