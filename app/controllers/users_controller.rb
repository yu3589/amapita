class UsersController < ApplicationController
  def show
    @user = User.find(params[:id]).decorate
    @posts = @user.posts.order(created_at: :desc).decorate
    @sweetness_type = @user.sweetness_type
    @sweetness_profiles = @user.sweetness_profiles.last
  end
end
