class PostDecorator < Draper::Decorator
  delegate_all

  COMMON_VARIANT_OPTIONS = { resize_to_fill: [ 400, 400 ], format: :webp, saver: { quality: 85 } }.freeze

  def post_image(**options)
    default_classes = "object-cover"
    custom_classes  = options[:class]
    merged_classes  = [ default_classes, custom_classes ].compact.join(" ")

    h.image_tag(
      object.image.attached? ? object.image.variant(COMMON_VARIANT_OPTIONS) : "default_image.png",
      options.merge(class: merged_classes)
    )
  end
end
