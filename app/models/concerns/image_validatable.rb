module ImageValidatable
  extend ActiveSupport::Concern

  included do
    validate :image_type_and_size, if: -> { respond_to?(:image) && image.attached? }
    validate :avatar_type_and_size, if: -> { respond_to?(:avatar) && avatar.attached? }
  end

  private

  def image_type_and_size
    validate_attachment(:image)
  end

  def avatar_type_and_size
    validate_attachment(:avatar)
  end

  def validate_attachment(attachment_name)
    attachment = send(attachment_name)
    return unless attachment.attached?

    unless attachment.content_type.in?(%w[image/png image/jpg image/jpeg image/webp])
      errors.add(attachment_name, "はJPG・JPEG・PNG・WebP形式のファイルのみ対応しています")
    end

    if attachment.blob.byte_size > 5.megabytes
      errors.add(attachment_name, "は5MB以下にしてください")
    end
  end
end
