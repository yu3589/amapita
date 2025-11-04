class ProductsController < ApplicationController
  def show
    @product = Product.find(params[:id]).decorate

    published_posts = @product.posts.publish.includes(:user)

    if user_signed_in?
      @user_unpublish_post = @product.posts.unpublish.find_by(user_id: current_user.id)
    end

    @posts = published_posts.order(created_at: :desc)
    @unpublish_posts = @product.posts.unpublish
    @average_scores = @product.average_sweetness_scores
    @user_post = published_posts.find_by(user_id: current_user.id) if user_signed_in?

    # レビュー一覧
    @pagy, @posts = pagy(@posts, limit: 3)
  end
end
