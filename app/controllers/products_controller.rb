class ProductsController < ApplicationController
  def show
    @product = Product.find(params[:id]).decorate

    posts_query = @product.posts.includes(:user).order(created_at: :desc)

    @posts = @product.decorate.posts.includes(:user).order(created_at: :desc)
    @average_scores = @product.average_sweetness_scores
    @user_post = @posts.find_by(user_id: current_user.id) if user_signed_in?

    @product_image_uploader = @product.posts.includes(:user).order(:created_at).first
    @product_image_uploader_id = @product_image_uploader&.user_id
    # レビュー一覧
    @pagy, @posts = pagy(@posts, limit: 5)
  end
end
