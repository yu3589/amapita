class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc)
    @sweetness_type = @user.sweetness_type
    @sweetness_profiles = @user.sweetness_profiles.last
  end
end
