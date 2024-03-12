class Post < ApplicationRecord
  has_rich_text :content
  has_many_attached :images
  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

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
end
