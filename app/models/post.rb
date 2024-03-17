class Post < ApplicationRecord
  include Notifiable

  has_rich_text :content
  has_many_attached :images
  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true

  # フォロー・フォロワー機能のメソッド
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  # 検索機能のメソッド
  def self.search_for(content, method)
    if method == 'perfect'
      Post.where(title: content)
    elsif method == 'forward'
      Post.where('title LIKE ?', content + '%')
    elsif method == 'backward'
      Post.where('title LIKE ?', '%' + content)
    else
      Post.where('title LIKE ?', '%' + content + '%')
    end
  end

  after_create do
    records = user.followers.map do |follower|
      notifications.new(user_id: follower.id)
    end
    Notification.import records
  end
end
