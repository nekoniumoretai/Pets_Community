class Pet < ApplicationRecord
  has_one_attached :image
  belongs_to :user

  validates :name, presence: true, length: { maximum: 50 }
  validates :kind, presence: true
  validates :gender, presence: true
end
