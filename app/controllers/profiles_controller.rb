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
    @sweetness_profiles = @user.sweetness_profiles.last
    @sweetness_type =  @user.sweetness_type

    # デフォルトは投稿タブ
    @active_tab = params[:tab].presence_in([ "posts", "liked_posts" ]) || "posts"
    # 投稿
    posts_query = @user.posts.includes(
      :image_attachment,
      user: :avatar_attachment,
      product: :image_attachment
      )
    .order(id: :desc)
    @pagy_posts, @posts = pagy(posts_query, limit: 2, page_param: :posts_page)
    @posts = @posts&.decorate
    # いいね
    liked_posts_query = @user.like_posts.includes(
      :image_attachment,
      user: :avatar_attachment,
      product: :image_attachment
    ).publish
    .order("likes.created_at DESC")

    @pagy_likes, @likes = pagy(liked_posts_query, limit: 2, page_param: :liked_posts_page)
    @likes = @likes&.decorate
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
