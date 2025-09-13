class SweetnessProfile < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :sweetness_type

  scope :near_sweetness_strength, ->(value, range = 1) {
    min_val = [ value - range, 1 ].max
    max_val = [ value + range, 5 ].min
    where(sweetness_strength: min_val..max_val)
  }
  scope :near_aftertaste_clarity, ->(value, range = 1) {
    min_val = [ value - range, 1 ].max
    max_val = [ value + range, 5 ].min
    where(aftertaste_clarity: min_val..max_val)
  }

  before_create :generate_token

  def self.latest_profile(user_id)
    where(user_id: user_id).order(created_at: :desc).first
  end

  def sweetness_kind
    diagnoser = Diagnosis::SweetnessTypeProcessor.new(
      {
        "sweetness_strength" => sweetness_strength,
        "aftertaste_clarity" => aftertaste_clarity,
        "natural_sweetness" => natural_sweetness,
        "coolness" => coolness,
        "richness" => richness
      }
    )
    diagnoser.send(:diagnose_kind, diagnoser.call[:scores])
  end

  private

  def generate_token
    loop do
      self.token = SecureRandom.uuid
      break unless SweetnessProfile.exists?(token: token)
    end
  end
end
