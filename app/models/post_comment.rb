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

  # 検索機能のメソッド
  def self.search_for(content, method)
    if method == 'perfect'
      PostComment.where(comment: content)
    elsif method == 'forward'
      PostComment.where('comment LIKE ?', content + '%')
    elsif method == 'backward'
      PostComment.where('comment LIKE ?', '%' + content)
    else
      PostComment.where('comment LIKE ?', '%' + content + '%')
    end
  end
end
