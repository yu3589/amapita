class Notification < ApplicationRecord
  validates :action, presence: true
  validates :checked, inclusion: { in: [ true, false ] }

  belongs_to :sender, class_name: "User", foreign_key: "sender_id"
  belongs_to :recipient, class_name: "User", foreign_key: "recipient_id"
  belongs_to :notifiable, polymorphic: true

  enum :action, { liked: 0, commented: 1 }
  scope :unchecked, -> { where(checked: false) }
end
