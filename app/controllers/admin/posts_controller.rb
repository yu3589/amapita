class Admin::PostsController < Admin::BaseController
  before_action :authenticate_user!

  def index
    @q = Post.ransack(params[:q])
    posts_scope = @q.result(distinct: true).includes(:user, :category).order(created_at: :desc)
    @total_count = posts_scope.count
    @pagy, @posts = pagy(posts_scope)
    @posts = @posts.decorate
  end

  def destroy
    @post = Post.find(params[:id])
    @post.image.purge if @post.image.attached?
    @post.destroy!
    redirect_to admin_posts_path, notice: t("defaults.flash_message.deleted", item: Post.model_name.human)
  end
end
