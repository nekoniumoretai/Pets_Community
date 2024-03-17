class PostComment < ApplicationRecord
  include Notifiable

  belongs_to :user
  belongs_to :post
  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :comment, presence: true

  after_create do
    user.followers.each do |post_comment|
      notifications.create(user_id: post_comment.id)
    end
  end
end
