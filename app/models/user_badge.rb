class UserBadge < ApplicationRecord
  validates :user_id, uniqueness: { scope: :badge_id }

  belongs_to :user
  belongs_to :badge
end
