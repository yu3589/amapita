require "open-uri"

class User < ApplicationRecord
  include ImageValidatable

  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable,
        :omniauthable, omniauth_providers: [ :google_oauth2 ]

  has_one_attached :avatar

  validates :name, presence: true, length: { maximum: 20 }, uniqueness: true
  validates :uid, presence: true, uniqueness: { scope: :provider }
  validates :self_introduction, length: { maximum: 100 }

  belongs_to :sweetness_type, optional: true
  has_many :sweetness_profiles, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_products, through: :bookmarks, source: :product
  has_many :user_badges, dependent: :destroy
  has_many :badges, through: :user_badges

  enum :role, { general: 0, admin: 1 }

  # providerとuidを使ってユーザーを検索、存在しなければ新規作成
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.name = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]

      if auth.info.image.present?
      downloaded_image = URI.open(auth.info.image)
      user.avatar.attach(io: downloaded_image, filename: "#{user.name}_avatar.jpg")
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
end
