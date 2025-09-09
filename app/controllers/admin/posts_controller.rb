class Admin::PostsController < Admin::BaseController
  before_action :authenticate_user!

  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true).all.order(created_at: :desc).decorate
    @total_count = @posts.count
  end

  def destroy
    @post = Post.find(params[:id])
    @post.image.purge if @post.image.attached?
    @post.destroy!
    redirect_to admin_posts_path, notice: t("defaults.flash_message.deleted", item: Post.model_name.human)
  end
end
