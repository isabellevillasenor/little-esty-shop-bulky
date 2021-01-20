class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :merchant_id,
                        :customer_id

  belongs_to :merchant
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :bulk_discounts, through: :merchant
  # model test this ^

  enum status: [:cancelled, :in_progress, :complete]

  def revenue_before_discount
    invoice_items.sum("unit_price * quantity")
  end

  def total_revenue
    invoice_items.each do |ii|
      ii.new_unit_price
    end
    invoice_items.sum("unit_price * quantity")
  end

end
