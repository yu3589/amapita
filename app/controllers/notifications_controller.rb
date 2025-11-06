class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.received_notifications
                                 .includes(
                                  :sender,
                                  :notifiable,
                                  sender: :avatar_attachment,
                                  notifiable: { post: :product }
                                 )
                                 .order(created_at: :desc)
    @pagy, @notifications = pagy(@notifications, limit: 12)
  end

  def update
    @notification = current_user.received_notifications.find(params[:id])
    @notification.update!(checked: true)
    redirect_to post_path(@notification.notifiable.post)
  end

  def mark_all_as_read
    current_user.received_notifications.unchecked.update(checked: true)
    redirect_to notifications_path
  end
end
