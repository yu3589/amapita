class DiagnosesController < ApplicationController
  DIAGNOSIS_QUESTIONS = YAML.load_file(Rails.root.join("config/diagnosis_questions.yml"))["questions"]

  def new
    @questions = DIAGNOSIS_QUESTIONS
  end

  def create
    if unanswered_questions?
      @questions = DIAGNOSIS_QUESTIONS
      @selected_answers = diagnosis_params.to_h
      flash.now[:modal_alert] = "未回答の設問があります。"
      render :new, status: :unprocessable_entity
      return
    end

    diagnoser = Diagnosis::SweetnessDiagnoser.new(diagnosis_params)
    result = diagnoser.call

    sweetness_type = SweetnessType.find_by(sweetness_kind: SweetnessType.sweetness_kinds[result[:sweetness_kind].to_s])
    profile = SweetnessProfile.create!(
      user_id: current_user&.id,
      sweetness_type_id: sweetness_type&.id,
      sweetness_strength: result[:scores][:sweetness_strength],
      aftertaste_clarity: result[:scores][:aftertaste_clarity],
      natural_sweetness: result[:scores][:natural_sweetness],
      coolness: result[:scores][:coolness],
      richness: result[:scores][:richness],
    )
    if current_user
      current_user.update(sweetness_type_id: profile.sweetness_type_id)
    end
    redirect_to diagnosis_result_path(profile.token)
  end

  def show
    @profile = SweetnessProfile.find_by!(token: params[:token])
    @sweetness_kind = @profile.sweetness_kind
  end

  private

  def unanswered_questions?
    return true if params[:diagnosis].blank?

    required_keys = DIAGNOSIS_QUESTIONS.map { |q| q["category"] }
    required_keys.any? { |key| diagnosis_params[key].blank? }
  end

  def diagnosis_params
    params.fetch(:diagnosis, {}).permit(
      :sweetness_strength,
      :aftertaste_clarity,
      :natural_sweetness,
      :coolness,
      :richness
    )
  end
end
