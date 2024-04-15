class Group < ApplicationRecord
  has_many :group_users, dependent: :destroy
  belongs_to :owner, class_name: "User"
  has_many :users, through: :group_users, source: :user
  # has_many :group_message, dependent: :destroy

  validates :name, presence: true, length: { maximum: 30 }
  validates :introduction, presence: true
  has_one_attached :group_image

  # オーナーIDとユーザーIDが同じかどうか判断するメソッド
  def is_owned_by?(user)
    owner.id == user.id
  end

  # コミュニティに参加しているかどうかを判断するメソッド
  def includesUser?(user)
    group_users.exists?(user_id: user.id)
  end
end
