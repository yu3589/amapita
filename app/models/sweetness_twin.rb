class SweetnessTwin < ApplicationRecord
  belongs_to :user
  belongs_to :twin_user, class_name: "User"
end
