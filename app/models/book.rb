class Book < ApplicationRecord
  belongs_to :category
  has_many :favorites, dependent: :destroy
  has_many :favorited_by, through: :favorites, source: :user
  has_one_attached :image

  default_scope { order(:id) } 
  PERMITTED_PARAMS = [:name, :author_name, :description, :category_id, :image]

  def self.search_books(search)
    joins(:category).where('books.name ILIKE :search OR books.description ILIKE :search OR books.author_name ILIKE :search OR categories.name ILIKE :search', search: "%#{search}%").distinct
  end

  def display_image
    image.variant(resize: "100x100").processed if image.attached?
  end
end
