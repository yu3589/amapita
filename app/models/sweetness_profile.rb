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

  def sweetness_kind
    diagnoser = Diagnosis::SweetnessDiagnoser.new(
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
end
