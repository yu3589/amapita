class SweetnessProfile < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :sweetness_type
end
