class PostDecorator < Draper::Decorator
  delegate_all

  POST_VARIANT_OPTIONS = { resize_to_fill: [ 200, 200 ], format: :webp, saver: { quality: 75 } }.freeze

  def post_image(**options)
    default_classes = "object-cover"
    custom_classes  = options[:class]
    merged_classes  = [ default_classes, custom_classes ].compact.join(" ")

    h.image_tag(
      object.image.attached? ? object.image.variant(POST_VARIANT_OPTIONS) : "default_image.png",
      options.merge(class: merged_classes)
    )
  end
end
