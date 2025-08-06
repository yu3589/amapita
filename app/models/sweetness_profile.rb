class SweetnessProfile < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :sweetness_type

  before_create :generate_token

  def generate_token
    loop do
      self.token = SecureRandom.uuid
      break unless SweetnessProfile.exists?(token: token)
    end
  end
end
