class Product < ActiveRecord::Base
  validates_presence_of :title, :user_id
  validates :price, numericality: { greater_than_or_equal_to: 0},
                    presence: true
end
