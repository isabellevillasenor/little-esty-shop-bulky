require 'rails_helper'

describe Invoice do
  describe 'validations' do
    it { should validate_presence_of :status }
    it { should validate_presence_of :merchant_id }
    it { should validate_presence_of :customer_id }
  end

  describe 'relationships' do
    it { should belong_to :merchant }
    it { should belong_to :customer }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many :transactions}
  end

  describe 'instance methods' do
    before :each do
      @m1 = Merchant.create!(name: 'Merchant 1')
      
      @i1 = @m1.items.create!(name: 'Shampoo', description: 'This washes your hair', unit_price: 10, status: 1)
      @i8 = @m1.items.create!(name: 'Butterfly Clip', description: 'This holds up your hair but in a clip', unit_price: 5)
      
      @c1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      
      @inv1 = Invoice.create!(merchant_id: @m1.id, customer_id: @c1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @inv2 = Invoice.create!(merchant_id: @m1.id, customer_id: @c1.id, status: 2, created_at: "2012-03-27 14:54:09")
  
      @ii_1 = InvoiceItem.create!(invoice_id: @inv1.id, item_id: @i1.id, quantity: 9, unit_price: 10, status: 2)
      @ii_2 = InvoiceItem.create!(invoice_id: @inv1.id, item_id: @i8.id, quantity: 1, unit_price: 10, status: 1)
      @ii_3 = InvoiceItem.create!(invoice_id: @inv2.id, item_id: @i1.id, quantity: 15, unit_price: 10, status: 1)
    end

    describe '#revenue_before_discount' do
      it 'should give the total revenue before a discount is applided' do
        expect(@inv1.revenue_before_discount).to eq(100)
      end
    end

    describe '#total_revenue' do
      it 'should give the total revenue of an invoice without a discount' do
        expect(@inv2.total_revenue).to eq(150)
      end
      
      it 'should give the total revenue of an invoice with a discount' do
        @m1.bulk_discounts.create!(quantity: 15, discount: 5)
        expect(@inv2.total_revenue).to eq(142.5)
      end
    end
  end
end
