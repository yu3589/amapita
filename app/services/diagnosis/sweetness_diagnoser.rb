module Diagnosis
  class SweetnessDiagnoser
    def initialize(answers)
      @answers = answers
    end

    def call
      calculate_scores
    end

    private

    def calculate_scores
      {
        sweetness_strength: @answers["sweetness_strength"].to_i,
        aftertaste_clarity: @answers["aftertaste_clarity"].to_i,
        natural_sweetness: @answers["natural_sweetness"].to_i,
        coolness: @answers["coolness"].to_i,
        richness: @answers["richness"].to_i
      }
    end
  end
end
