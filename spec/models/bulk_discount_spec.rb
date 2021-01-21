require 'rails_helper'

describe BulkDiscount do 
  describe 'validations' do
    it { should validate_numericality_of(:quantity).is_greater_than(0) }
    it { should validate_numericality_of(:discount).is_greater_than(0) }
    it { should validate_numericality_of(:discount).is_less_than(100) }
  end

  describe 'relationships' do
    it { should belong_to :merchant }
  end
  
  describe 'instance methods' do
    describe "#discount_price" do
      it 'should return the discounted price if a discount is applied' do
        @m1 = Merchant.create!(name: 'Merchant 1')
        @c1 = Customer.create!(first_name: 'Yo', last_name: 'Yoz', address: '123 Heyyo', city: 'Whoville', state: 'CO', zip: 12345)
        @i1 = Invoice.create!(merchant_id: @m1.id, customer_id: @c1.id, status: 2, created_at: '2012-03-25 09:54:09')
        @item_2 = @m1.items.create!(name: 'rest', description: 'dont test me', unit_price: 12)
        @ii_3 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_2.id, quantity: 87, unit_price: 12, status: 2)
        @t1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @i1.id)

        expect(@i1.total_revenue).to eq(1044)

        @d1 = @m1.bulk_discounts.create!(discount: 20.0, quantity:30)

        expect(@i1.total_revenue.round(2)).to eq(835.2)
      end
    end
  end

end