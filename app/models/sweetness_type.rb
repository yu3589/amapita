class SweetnessType < ApplicationRecord
  has_many :users

  enum :sweetness_kind, {
    fresh_natural: 0,
    rich_romantic: 1,
    sweet_dreamer: 2,
    balance_seeker: 3
  }
end
