class CategoriesController < ApplicationController
  def index
    @categories = Category.all.order(:name)
  end

  def show
    @category = Category.find_by!(slug: params[:slug])
    # カテゴリ内の商品のみで検索
    @q = @category.products.ransack(params[:q])
    @products = @q.result(distinct: true).includes(:posts).order(created_at: :desc)
  end
end
