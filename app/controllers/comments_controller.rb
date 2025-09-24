class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: %i[create]

  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      respond_to do |format|
        format.html { redirect_to @post }
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html { redirect_to @post, status: :unprocessable_entity }
        format.turbo_stream
      end
    end
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy!
    respond_to do |format|
      format.html { redirect_to @post }
      format.turbo_stream
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:body).merge(post_id: params[:post_id])
  end
end
