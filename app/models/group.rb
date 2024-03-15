class Group < ApplicationRecord
  has_many :group_users, dependent: :destroy
  belongs_to :owner, class_name: 'User'
  has_many :users, through: :group_users, source: :user
  belongs_to :group_message

  validates :name, presence: true
  validates :introduction, presence: true
  has_one_attached :group_image

# オーナーIDとユーザーIDが
  def is_owned_by?(user)
    owner.id == user.id
  end
  
# コミュニティに参加しているかどうかを判断するメソッド
  def includesUser?(user)
    group_users.exists?(user_id: user.id)
  end

end
