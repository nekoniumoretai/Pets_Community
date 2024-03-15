class PostTag < ApplicationRecord
  belongs_to :post, dependent: :destroy
  belongs_to :tag
end
