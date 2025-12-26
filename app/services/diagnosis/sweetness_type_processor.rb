module Diagnosis
  class SweetnessTypeProcessor
    TYPE_DECISION_THRESHOLD = 4
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
      if scores[:sweetness_strength] >= TYPE_DECISION_THRESHOLD && scores[:richness] >= TYPE_DECISION_THRESHOLD
        :rich_romantic
      elsif scores[:sweetness_strength] == scores.values.max && scores[:sweetness_strength] >= TYPE_DECISION_THRESHOLD
        :sweet_dreamer
      elsif (scores[:coolness] == scores.values.max || scores[:natural_sweetness] == scores.values.max) &&
            (scores[:coolness] >= TYPE_DECISION_THRESHOLD || scores[:natural_sweetness] >= TYPE_DECISION_THRESHOLD)
        :fresh_natural
      else
        :balance_seeker
      end
    end
  end
end
