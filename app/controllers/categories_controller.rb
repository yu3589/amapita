class CategoriesController < ApplicationController
  skip_before_action :authenticate_user!
  def index
    @categories = Category.all.order(:name)
  end

  def show
    @category = Category.find_by!(slug: params[:slug])
    # カテゴリ内の商品のみで検索
    @q = @category.products.ransack(params[:q])
    products_result = @q.result(distinct: true).includes(:posts).order(created_at: :desc)

    @pagy, @products = pagy(products_result)
    @product_stats = product_stats(@products)
  end

  private

  def product_stats(products)
    stats = {}

    products.each do |product|
      next if product.nil?

      total_posts = product.posts.count || 0
      perfect_sweetness_count = product.posts.where(sweetness_rating: :perfect_sweetness).count

      stats[product.id] = {
        total_posts: total_posts,
        perfect_sweetness_count: perfect_sweetness_count
      }
    end

    stats
  end
end
