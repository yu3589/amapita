class Comment < ApplicationRecord
  validates :body, presence: true, length: { maximum: 65_535 }

  belongs_to :user
  belongs_to :post
  has_many :notifications, as: :notifiable, dependent: :destroy

  after_create_commit :create_comment_notification

  def create_comment_notification
    return if self.user_id == self.post.user_id

    unless Notification.exists?(
        sender_id: self.user_id,
        recipient_id: self.post.user_id,
        notifiable: self,
        action: :commented
    )
    Notification.create(
        sender_id: self.user_id,
        recipient_id: self.post.user_id,
        notifiable: self,
        action: :commented
    )
    end
  end
end
