class Relationship < ApplicationRecord
  include Notifiable

  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  has_many :notifications, as: :notifiable, dependent: :destroy

  after_create do
    Notification.create(notifiable: self, user_id: followed_id)
  end
end