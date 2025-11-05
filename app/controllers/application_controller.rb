class ApplicationController < ActionController::Base
  include Pagy::Backend

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_unchecked_notifications_count
  allow_browser versions: :modern

  rescue_from ActiveRecord::RecordNotFound do |exception|
    redirect_to root_path, alert: "無効なURLです"
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :role ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :role ])
  end

  private

  def set_unchecked_notifications_count
    if user_signed_in?
      @unchecked_notifications_count = current_user.received_notifications.unchecked.count
    end
  end

  # あまピタカウント
  def product_stats(products)
    stats = {}

    products.each do |product|
      next if product.nil?

      total_posts = product.posts.publish.count || 0
      perfect_sweetness_count = product.posts.publish.where(sweetness_rating: :perfect_sweetness).count

      stats[product.id] = {
        total_posts: total_posts,
        perfect_sweetness_count: perfect_sweetness_count
      }
    end

    stats
  end
end
