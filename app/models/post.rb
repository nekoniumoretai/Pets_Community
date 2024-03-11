class Post < ApplicationRecord
  has_rich_text :content
  has_many_attached :images
  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
end
