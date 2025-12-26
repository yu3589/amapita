class SweetnessProfile < ApplicationRecord
  TWIN_MATCH_RANGE = 1
  MINIMUM_SWEETNESS_SCORE = 1
  MAXIMUM_SWEETNESS_SCORE = 5

  belongs_to :user, optional: true
  belongs_to :sweetness_type

  scope :near_sweetness_strength, ->(value, range = TWIN_MATCH_RANGE) {
    min_val = [ value - range, MINIMUM_SWEETNESS_SCORE ].max
    max_val = [ value + range, MAXIMUM_SWEETNESS_SCORE ].min
    where(sweetness_strength: min_val..max_val)
  }
  scope :near_aftertaste_clarity, ->(value, range = TWIN_MATCH_RANGE) {
    min_val = [ value - range, MINIMUM_SWEETNESS_SCORE ].max
    max_val = [ value + range, MAXIMUM_SWEETNESS_SCORE ].min
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
