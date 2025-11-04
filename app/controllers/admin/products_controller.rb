class Admin::ProductsController < Admin::BaseController
  def index
    @q = Product.ransack(params[:q])
    products_scope = @q.result(distinct: true).includes(:category).order(created_at: :desc)
    @total_count = products_scope.count
    @pagy, @products = pagy(products_scope)
    @products = @products.decorate
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    @product.user = current_user
    if @product.save
      redirect_to admin_products_path, notice: t("defaults.flash_message.registered", item: Product.model_name.human)
    else
      flash.now[:alert] = t("defaults.flash_message.not_registered", item: Product.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to admin_products_path, notice: t("defaults.flash_message.updated", item: Product.model_name.human)
    else
      flash.now[:alert] = t("defaults.flash_message.not_updated", item: Product.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.image.purge if @product.image.attached?
    @product.destroy!
    redirect_to admin_products_path, notice: t("defaults.flash_message.deleted", item: Product.model_name.human)
  end

    private

  def product_params
    params.require(:product).permit(:name, :manufacturer, :category_id, :image, :product_url, :product_image_url)
  end
end
