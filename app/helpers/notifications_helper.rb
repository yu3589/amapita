module NotificationsHelper
  def notification_text_class(notification)
    notification.checked ? "text-stone-400" : "text-neutral"
  end
end
