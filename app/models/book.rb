class Book < ApplicationRecord
  belongs_to :category
  belongs_to :author
  has_many :favorites, dependent: :destroy
  has_many :favorited_by, through: :favorites, source: :user
  has_one_attached :image
  validates :name, uniqueness: true

  default_scope { order(:id) } 
  PERMITTED_PARAMS = [:name, :author_id, :description, :category_id, :image]

  def self.search_books(search)
    Book.joins(:category, :author).where('books.name ILIKE :search OR books.description ILIKE :search OR categories.name ILIKE :search OR authors.name ILIKE :search', search: "%#{search}%").distinct
  end

  def display_image
    image.variant(resize: "50x50").processed if image.attached?
  end
end
