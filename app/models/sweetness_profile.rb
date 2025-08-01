class SweetnessProfile < ApplicationRecord
  belongs_to :user
  belongs_to :sweetness_type
end
