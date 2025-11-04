require "open-uri"

class User < ApplicationRecord
  include ImageValidatable

  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable,
        :omniauthable, omniauth_providers: [ :google_oauth2 ]

  has_one_attached :avatar

  validates :name, presence: true, length: { maximum: 20 }, uniqueness: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP },
            uniqueness: { case_sensitive: false }
  validates :uid, presence: true, uniqueness: { scope: :provider }
  validates :self_introduction, length: { maximum: 100 }

  belongs_to :sweetness_type, optional: true
  has_many :sweetness_profiles, dependent: :destroy
  has_many :products
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_posts, through: :likes, source: :post
  has_many :comments, dependent: :destroy
  has_many :comment_posts, through: :comments, source: :post
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_products, through: :bookmarks, source: :product
  has_many :user_badges, dependent: :destroy
  has_many :badges, through: :user_badges
  has_many :sweetness_twins, dependent: :destroy
  has_many :twin_users, through: :sweetness_twins, source: :twin_user
  has_many :sent_notifications, class_name: "Notification", foreign_key: "sender_id", dependent: :destroy
  has_many :received_notifications, class_name: "Notification", foreign_key: "recipient_id", dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy

  enum :role, { general: 0, admin: 1 }

  # providerとuidを使ってユーザーを検索、存在しなければ新規作成
  def self.from_omniauth(auth)
    # 既存のGoogleアカウントを探す
    user = find_by(provider: auth.provider, uid: auth.uid)
    return user if user

    # 同じメールアドレスの既存ユーザーにGoogle認証を紐付ける
    existing_user = find_by(email: auth.info.email)
    if existing_user
      begin
        existing_user.update!(
          provider: auth.provider,
          uid: auth.uid,
          name: existing_user.name.presence || auth.info.name.presence
          )
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.error "OmniAuth update failed: #{e.record.errors.full_messages.join(', ')}"
      end
      return existing_user
    end

    # Googleユーザーを新規作成
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.name = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]

      if auth.info.image.present?
        begin
          downloaded_image = URI.open(auth.info.image)
          user.avatar.attach(io: downloaded_image, filename: "#{user.name}_avatar.jpg")
        rescue => e
          Rails.logger.warn "Avatar download failed: #{e.message}"
        end
      end
    end
  end

  def self.create_unique_string
    SecureRandom.uuid
  end

  def own?(object)
    id == object&.user_id
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "name" ]
  end

  def profile_image_url
    if avatar.attached?
      Rails.application.routes.url_helpers.url_for(avatar)
    else
      nil # デフォルト画像はDecoratorで処理
    end
  end

  def bookmark(product)
    bookmark_products << product
  end

  def unbookmark(product)
    bookmark_products.destroy(product)
  end

  def bookmark?(product)
    bookmark_products.include?(product)
  end

  def sweetness_twin_badges
    badges.where(badge_kind: :sweetness_twin)
  end

  def post_badges
    badges.where(badge_kind: :post_count)
  end

  def like(post)
    like_posts << post
  end

  def liked(post)
    like_posts.destroy(post)
  end

  def like?(post)
    like_posts.include?(post)
  end
end
