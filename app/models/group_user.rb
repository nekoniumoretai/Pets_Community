class GroupUser < ApplicationRecord
  belongs_to :user
  belongs_to :group
  belongs_to :group_message
end
