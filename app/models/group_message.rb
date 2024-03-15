class GroupMessage < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :groups, dependent: :destroy
end
