class Author < ApplicationRecord
  has_many :books, dependent: :destroy
  PERMITTED_PARAMS = [:name]
  default_scope { order(:id) }
  validates :name, uniqueness: true
end