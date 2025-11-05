class ProductsController < ApplicationController
  before_action :authenticate_user!, only: %i[show]

  def index
    @q = Product.ransack(params[:q])
    products_result = @q.result(distinct: true)
                        .includes(:posts)
                        .order(manufacturer: :asc, name: :asc)
    @pagy, @products = pagy(products_result)
    @product_stats = product_stats(@products)
  end

  def show
    @product = Product.find(params[:id]).decorate
    setup_product_details
  end

  def autocomplete
    query = params[:q]

    if query.blank?
      @products = Product.none
    else
      @products = Product.where("name ILIKE ? OR manufacturer ILIKE ?", "%#{query}%", "%#{query}%")
                        .select(:id, :name, :manufacturer)
    end

    respond_to do |format|
      format.html { render partial: "products/autocomplete_suggestions", locals: { products: @products } }
    end
  end

  private

  def setup_product_details
    published_posts = @product.posts.publish.includes(:user)

    if user_signed_in?
      @user_unpublish_post = @product.posts.unpublish.find_by(user_id: current_user.id)
    end

    @posts = published_posts.order(created_at: :desc)
    @unpublish_posts = @product.posts.unpublish
    @average_scores = @product.average_sweetness_scores
    @user_post = published_posts.find_by(user_id: current_user.id) if user_signed_in?

    @pagy, @posts = pagy(@posts, limit: 3)
  end
end
