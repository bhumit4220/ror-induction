class Category < ApplicationRecord
  has_many :books
  PERMITTED_PARAMS = [:name]
end