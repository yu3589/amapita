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
  has_many :posts

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

    def google_avatar_url
      # OAuth情報があればURLを返す
      @google_avatar_url ||= begin
      omniauth_data = self[:omniauth_data] # セッション等に保存しておく場合
      omniauth_data[:info][:image] if omniauth_data
    end
  end

  def profile_image_url
    if avatar.attached?
      # Active Storageの画像を優先
      Rails.application.routes.url_helpers.url_for(avatar)
    elsif google_avatar_url.present?
      # Google認証で取得した画像URL
      google_avatar_url
    else
      nil # デフォルト画像はDecoratorで処理
    end
  end
end
