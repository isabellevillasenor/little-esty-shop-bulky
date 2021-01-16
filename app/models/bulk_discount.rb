class BulkDiscount < ApplicationRecord
  belongs_to :merchant

  validates_numericality_of :quantity, :discount, greater_than: 0
  validates_numericality_of :discount, less_than: 100
end