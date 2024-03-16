class GroupUser < ApplicationRecord
  belongs_to :user
  belongs_to :group
  # has_many :group_messages, dependent: :destroy
end
