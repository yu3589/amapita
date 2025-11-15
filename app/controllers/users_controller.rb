class UsersController < ApplicationController
  def show
    @user = User.includes(:avatar_attachment)
                .find(params[:id])
                .decorate
    @sweetness_profiles = @user.sweetness_profiles.last
    @sweetness_type = @user.sweetness_type

    # 投稿一覧
    posts_query = @user.posts.publish.includes(
                                  :image_attachment,
                                  product: :image_attachment
                                ).order(id: :desc)
    @pagy_posts, @posts = pagy(posts_query, limit: 2)
    @posts = @posts&.publish.decorate
  end
end
