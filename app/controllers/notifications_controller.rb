class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.received_notifications
                                 .includes(:sender, :notifiable)
                                 .order(created_at: :desc)
    @pagy, @notifications = pagy(@notifications, limit: 15)
  end

  def update
    notification = current_user.received_notifications.find(params[:id])
    notification.update!(checked: true)

    respond_to do |format|
      format.turbo_stream
      format.html do
        # 通知の対象へリダイレクト
        case notification.notifiable_type
        when "Like", "Comment"
          redirect_to post_path(notification.notifiable.post)
        else
          redirect_to notifications_path
        end
      end
    end
  end

  def mark_all_as_read
    current_user.received_notifications.unchecked.update_all(checked: true)
    @notifications = current_user.received_notifications.order(created_at: :desc)
    respond_to do |format|
        format.turbo_stream
        format.html { redirect_to notifications_path }
    end
  end
end
