class InvoiceItem < ApplicationRecord
  validates_presence_of :invoice_id,
                        :item_id,
                        :quantity,
                        :unit_price,
                        :status

  belongs_to :invoice
  belongs_to :item
  has_many :merchants, through: :item
  has_many :bulk_discounts, through: :merchants

  enum status: [:pending, :packaged, :shipped]

  def self.incomplete_invoices
    Invoice.joins(:invoice_items)
           .where("invoice_items.status = 0 or invoice_items.status = 1")
           .order(:created_at)
           .distinct
  end

  def find_discount
    BulkDiscount.where(merchant_id: self.item.merchant_id)
                .where('bulk_discounts.quantity <= ?', self.quantity)
                .order(discount: :desc)
                .first
  end

  def new_unit_price
    discount = self.find_discount
    if discount
      self.update(unit_price: discount.discounted_price(item.unit_price))
    else
      self
    end
  end

end
