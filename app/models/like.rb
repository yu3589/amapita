class Like < ApplicationRecord
  validates :user_id, uniqueness: { scope: :post_id }

  belongs_to :user
  belongs_to :post
  has_many :notifications, as: :notifiable, dependent: :destroy

  after_create_commit :create_liked_notification

  def create_liked_notification
    return if self.user_id == self.post.user_id

    unless Notification.exists?(
        sender_id: self.user_id,
        recipient_id: self.post.user_id,
        notifiable: self,
        action: :liked
    )
    Notification.create(
        sender_id: self.user_id,
        recipient_id: self.post.user_id,
        notifiable: self,
        action: :liked
    )
    end
  end
end
