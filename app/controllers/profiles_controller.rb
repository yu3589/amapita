class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def edit
    @google_user = current_user.provider == "google_oauth2"
  end

  def update
    if @user.update(user_params)
      redirect_to profile_path(@user), notice: t("defaults.flash_message.updated", item: t("profiles.info"))
    else
      flash.now[:alert] = t("defaults.flash_message.not_updated", item: t("profiles.info"))
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    @sweetness_type =  @user.sweetness_type
    @sweetness_profiles = @user.sweetness_profiles.last
    @posts = @user.posts.all.order(created_at: :desc)
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:name, :email, :self_introduction)
  end
end
