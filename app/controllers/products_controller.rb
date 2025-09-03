class ProductsController < ApplicationController
  def show
    @product = Product.find(params[:id])
    @posts = @product.posts.order(created_at: :desc)
    @average_scores = @product.average_sweetness_scores
    @user_post = @posts.find_by(user_id: current_user.id) if user_signed_in?
  end
end
