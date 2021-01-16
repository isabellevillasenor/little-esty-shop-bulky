class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :merchant_id,
                        :customer_id

  belongs_to :merchant
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :bulk_discounts, through: :items

  enum status: [:cancelled, :in_progress, :complete]

  def total_revenue
    apply_discount
    invoice_items.sum("unit_price * quantity")
  end

  def apply_discount
    ii = self.invoice_items
    # require 'pry'; binding.pry
    self.items.each do |item|
      item.bulk_discounts.each do |discount|
        ii.each do |i_item|
          if i_item.quantity >= discount.quantity_threshold
            i_item.unit_price = (i_item.unit_price * (100 - discount.percentage_discount)/ 100)
          else
           i_item.unit_price = i_item.unit_price
          end
        end
      end
    end
  end

  def check_discount
    if i_item.quantity >= discount.quantity_threshold
      i_item.unit_price = (i_item.unit_price * (100 - discount.percentage_discount)/ 100)
    else
     i_item.unit_price = i_item.unit_price
    end
  end
end
