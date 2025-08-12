class PostsController < ApplicationController
  before_action :authenticate_user!, only: [ :new, :create ]

  def index
    @posts = Post.includes(:user).all.order(created_at: :desc)
  end

  def new
    @post = Post.new
    @post.build_post_sweetness_score
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:notice] = "投稿しました！"
      redirect_to posts_path
    else
      flash.now[:alert] = "投稿を作成できませんでした"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  private

  def post_params
    params.require(:post).permit(:product_name, :manufacturer, :category_id, :sweetness_rating, :review, :image,
    post_sweetness_score_attributes: [
      :sweetness_strength, :aftertaste_clarity, :natural_sweetness, :coolness, :richness
    ]
    )
  end
end
