class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    current_user.like(@post)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @post }
    end
  end

  def destroy
    like = current_user.likes.find(params[:id])
    @post = like.post
    like.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @post }
    end
  end
end
