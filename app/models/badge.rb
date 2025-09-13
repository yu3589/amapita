class Badge < ApplicationRecord
  validates :name, presence: true
  validates :badge_kind, presence: true

  has_many :user_badges, dependent: :destroy
  has_many :users, through: :user_badges

  enum :badge_kind, {
    post_count: 0,
    sweetness_twin: 1
  }

  scope :post_badges, -> { where(badge_kind: :post_count) }
  scope :available_for, ->(count) { post_badges.where("threshold <= ?", count).order(threshold: :desc) }

  scope :sweetness_twin_badges, -> { where(badge_kind: :sweetness_twin) }
end
