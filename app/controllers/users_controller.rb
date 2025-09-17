class UsersController < ApplicationController
  def show
    @user = User.find(params[:id]).decorate
    @posts = @user.posts.order(created_at: :desc).decorate
    @sweetness_type = @user.sweetness_type
    @sweetness_profiles = @user.sweetness_profiles.last

    @bookmarks = @user.bookmark_products.decorate
    @pagy_posts, @posts = pagy(@user.posts.order(id: :desc))
    @pagy_bookmarks, @products = pagy(@user.bookmarks.includes(:product).order(id: :desc))
  end
end
