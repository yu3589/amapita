class UserDecorator < Draper::Decorator
  delegate_all

  AVATAR_VARIANT_OPTIONS = { resize_to_fill: [ 80, 80 ], format: :webp, quality: 70 }.freeze

  def avatar_image(**options)
    default_classes = "rounded-full object-cover"
    custom_classes  = options[:class]
    merged_classes  = [ default_classes, custom_classes ].compact.join(" ")

    image_url = if object.avatar.attached?
      if object.avatar.blob.content_type == "image/webp"
        object.avatar
      else
      object.avatar.variant(UserDecorator::AVATAR_VARIANT_OPTIONS)
      end
    elsif object.profile_image_url.present?
      object.profile_image_url
    else
      "avatar.svg"
    end

    h.image_tag(image_url, options.merge(class: merged_classes))
  end
end
