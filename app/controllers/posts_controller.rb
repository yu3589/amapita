class PostsController < ApplicationController
  before_action :authenticate_user!, only: [ :new, :create ]

  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true).includes(:user).all.order(created_at: :desc)
  end

  def new
    @post = Post.new
    if params[:product_id].present?
      # 既存商品へのレビュー
      @post.product = Product.find(params[:product_id])
      @post.build_post_sweetness_score
    else
      # 新規商品登録と同時レビュー
      @post.build_product
      @post.build_post_sweetness_score
    end
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to post_path(@post), notice: t("defaults.flash_message.created", item: Post.model_name.human)
    else
      flash.now[:alert] = t("defaults.flash_message.not_created", item: Post.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @post = current_user.posts.find(params[:id])
  end

  def update
    @post = current_user.posts.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post), notice: t("defaults.flash_message.updated", item: Post.model_name.human)
    else
      flash.now[:alert] = t("defaults.flash_message.not_updated", item: Post.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def destroy
    @post = Post.find(params[:id])
    @post.image.purge if @post.image.attached?
    @post.destroy!
    redirect_to posts_path, notice: t("defaults.flash_message.deleted", item: Post.model_name.human)
  end

  private

  def post_params
    params.require(:post).permit(
    :sweetness_rating, :review, :product_id,
    product_attributes: [ :id, :name, :manufacturer, :category_id, :image ],
    post_sweetness_score_attributes: [
      :sweetness_strength, :aftertaste_clarity, :natural_sweetness, :coolness, :richness
    ]
    )
  end
end
