class Book < ApplicationRecord
  belongs_to :category
  has_one_attached :image
  PERMITTED_PARAMS = [:name, :author_name, :description, :category_id, :image]
end
