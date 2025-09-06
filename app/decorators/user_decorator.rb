class UserDecorator < Draper::Decorator
  delegate_all

  COMMON_VARIANT_OPTIONS = { resize_to_fill: [ 400, 400 ], format: :webp, saver: { quality: 85 } }.freeze

  def avatar_image(**options)
    default_classes = "rounded-full object-cover"
    custom_classes  = options[:class]
    merged_classes  = [ default_classes, custom_classes ].compact.join(" ")

    image_url = if object.avatar.attached?
      object.avatar.variant(UserDecorator::COMMON_VARIANT_OPTIONS)
    elsif object.profile_image_url.present?
      object.profile_image_url
    else
      "avatar.svg"
    end

    h.image_tag(image_url, options.merge(class: merged_classes))
  end
end
