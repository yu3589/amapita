module NotificationsHelper
  def notification_text_class(notification)
    notification.checked ? "text-base-200" : "text-neutral"
  end
end
