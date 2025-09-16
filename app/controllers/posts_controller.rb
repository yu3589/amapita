class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create]

  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true).includes(:user).all.order(created_at: :desc).decorate
    @recommended_posts = fetch_recommended_posts
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
      # バッジの付与
      new_badge = PostBadge.check_and_award_post_badges(current_user)
      # 新しいバッジであればモーダル表示
      flash[:badge_awarded] = new_badge.name if new_badge

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
    @post = Post.find(params[:id]).decorate
  end

  def destroy
    @post = Post.find(params[:id])
    @post.image.purge if @post.image.attached?
    @post.destroy!
    redirect_to posts_path, notice: t("defaults.flash_message.deleted", item: Post.model_name.human)
  end

  private

  def fetch_recommended_posts
    return Post.none unless user_signed_in?

    twin_user_ids = SweetnessTwin.where(user_id: current_user.id).pluck(:twin_user_id)
    Post.perfect_sweetness
        .where(user_id: twin_user_ids)
        .includes(:user)
        .order(created_at: :desc)
        .decorate
  end

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
