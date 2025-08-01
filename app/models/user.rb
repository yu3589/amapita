class User < ApplicationRecord
  belongs_to :current_sweetness_type, class_name: "SweetnessType", foreign_key: "sweetness_type_id", optional: true
  has_many :sweetness_profiles, dependent: :destroy

  validates :name, presence: true, length: { maximum: 10 }, uniqueness: true
  validates :uid, presence: true, uniqueness: { scope: :provider }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :google_oauth2 ]

  # providerとuidを使ってユーザーを検索、存在しなければ新規作成
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.name = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end

  def self.create_unique_string
    SecureRandom.uuid
  end
end
