class PostsController < ApplicationController

  def new
    @post = Post.new
    @post.build_post_sweetness_score
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:notice] = "投稿しました！"
      redirect_to root_path
    else
      flash.now[:alert] = "投稿を作成できませんでした"
      render :new, status: :unprocessable_entity
    end
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
