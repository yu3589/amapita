class CategoriesController < ApplicationController
  def index
  end

  def show
    @category = Category.find(params[:id])
    @products = @category.products.includes(:posts).order(created_at: :desc)
  end
end
