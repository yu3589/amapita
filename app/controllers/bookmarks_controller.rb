class BookmarksController < ApplicationController
  before_action :authenticate_user!

  def index
    bookmarks_query = current_user.bookmark_products
                                  .includes(:image_attachment)
                                  .order("bookmarks.created_at DESC")
    @pagy, @bookmarks = pagy(bookmarks_query, limit: 10)
    @bookmarks = @bookmarks&.decorate
  end

  def create
    @product = Product.find(params[:product_id])
    current_user.bookmark(@product)
      respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @product }
    end
  end

  def destroy
    @product = current_user.bookmarks.find(params[:id]).product
    current_user.unbookmark(@product)
    respond_to do |format|
    format.turbo_stream
    format.html { redirect_to @product }
    end
  end
end
