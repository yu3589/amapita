class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :set_google_user, only: %i[edit update]

  def edit;end

  def update
    if @user.update(user_params)
      redirect_to profile_path, notice: t("defaults.flash_message.updated", item: t("profiles.info"))
    else
      flash.now[:alert] = t("defaults.flash_message.not_updated", item: t("profiles.info"))
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    @user = @user.decorate
    @sweetness_type =  @user.sweetness_type
    @sweetness_profiles = @user.sweetness_profiles.last
    @posts = @user.posts.all.order(created_at: :desc).decorate
    @bookmarks = @user.bookmark_products
    @products = @user.bookmark_products.decorate
    @pagy_posts, @posts = pagy(@user.posts.order(id: :desc))
    @pagy_bookmarks, @bookmarks = pagy(@user.bookmarks.order(id: :desc))
  end

  private

  def set_user
    @user = current_user
  end

  def set_google_user
    @google_user = current_user&.provider == "google_oauth2"
  end

  def user_params
    params.require(:user).permit(:name, :email, :self_introduction, :avatar)
  end
end
