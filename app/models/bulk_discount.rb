class BulkDiscount < ApplicationRecord
validates_presence_of :percentage_discount
validates_presence_of :quantity_threshold

belongs_to :merchant
belongs_to :item
end
