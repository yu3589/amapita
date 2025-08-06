module Diagnosis
  class SweetnessDiagnoser
    def initialize(answers)
      @answers = answers
    end

    def call
      scores = calculate_scores
      {
        scores: scores,
        sweetness_kind: diagnose_kind(scores)
      }
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

    def diagnose_kind(scores)
      if scores[:sweetness_strength] >= 4 && scores[:richness] >= 4
        :rich_romantic
      elsif scores[:sweetness_strength] == scores.values.max && scores[:sweetness_strength] >= 4
        :sweet_dreamer
      elsif (scores[:coolness] == scores.values.max || scores[:natural_sweetness] == scores.values.max) &&
            (scores[:coolness] >= 4 || scores[:natural_sweetness] >= 4)
        :fresh_natural
      else
        :balance_seeker
      end
    end
  end
end
