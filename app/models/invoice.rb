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
    # require 'pry'; binding.pry
    invoice_items.sum("unit_price * quantity")
  end

  def apply_discount
    ii = self.invoice_items[0]
    # require 'pry'; binding.pry
    self.items.each do |item|
      item.bulk_discounts.each do |discount|
        
        if ii.quantity >= discount.quantity_threshold
          ii.unit_price = (ii.unit_price * (100 - discount.percentage_discount)/ 100)
        else
          ii.unit_price = ii.unit_price
        end
        # require 'pry'; binding.pry
      end
    end
  end
end
