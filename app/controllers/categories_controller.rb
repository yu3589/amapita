class CategoriesController < ApplicationController
  skip_before_action :authenticate_user!
  def index
    @categories = Category.all.order(:name)
    @q = Product.ransack(params[:q])
  end

  def show
    @category = Category.find_by!(slug: params[:slug])
    load_category_products
  end

  def products
    @category = Category.find_by!(slug: params[:category_slug])
    load_category_products

    if params.dig(:q, :name_or_manufacturer_cont).blank?
      redirect_to category_path(@category.slug)
      return
    end
    render "categories/show"
  end

  def products_autocomplete
    @category = Category.find_by!(slug: params[:category_slug])

    query = params[:q]

    if query.blank?
      @products = @category.products.none
    else
      @products = @category.products
                           .where("name ILIKE ? OR manufacturer ILIKE ?", "%#{query}%", "%#{query}%")
                           .select(:id, :name, :manufacturer)
    end

    respond_to do |format|
      format.html { render partial: "products/autocomplete_suggestions", locals: { products: @products } }
    end
  end

  private

  def load_category_products
    @q = @category.products.ransack(params[:q])
    products_result = @q.result(distinct: true)
                        .includes(:image_attachment)
                        .order(manufacturer: :asc, name: :asc)

    @pagy, @products = pagy(products_result)
    @product_stats = product_stats(@products)
  end
end
