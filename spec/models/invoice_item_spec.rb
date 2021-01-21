require 'rails_helper'

describe InvoiceItem do
  describe 'validations' do
    it { should validate_presence_of :invoice_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :status }
  end
  describe 'relationships' do
    it { should belong_to :invoice }
    it { should belong_to :item }
    it { should have_many(:merchants).through(:item) }
    it { should have_many(:bulk_discounts).through(:merchants) }
  end

  describe 'class methods' do
    before :each do 
      @m1 = Merchant.create!(name: 'Merchant 1')
      @m2 = Merchant.create!(name: 'Merchant 2')
      
      @d1 = @m1.bulk_discounts.create!(quantity: 15, discount: 5)
      @d2 = @m1.bulk_discounts.create!(quantity: 25, discount: 10)
      
      @i1 = @m1.items.create!(name: 'Shampoo', description: 'This washes your hair', unit_price: 10, status: 1)
      @i2 = @m1.items.create!(name: 'Conditioner', description: 'This makes your hair shiny', unit_price: 8)
      @i3 = @m1.items.create!(name: 'Brush', description: 'This takes out tangles', unit_price: 5)
      @i4 = @m1.items.create!(name: 'Hair tie', description: 'This holds up your hair', unit_price: 1)
      @i7 = @m1.items.create!(name: 'Scrunchie', description: 'This holds up your hair but is bigger', unit_price: 3)
      @i8 = @m1.items.create!(name: 'Butterfly Clip', description: 'This holds up your hair but in a clip', unit_price: 5)
      @i5 = @m2.items.create!(name: 'Bracelet', description: 'Wrist bling', unit_price: 200)
      @i6 = @m2.items.create!(name: 'Necklace', description: 'Neck bling', unit_price: 300)
      
      @c1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @c2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
      @c3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
      @c4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
      @c5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
      @c6 = Customer.create!(first_name: 'Herber', last_name: 'Coon')
      
      @inv1 = Invoice.create!(merchant_id: @m1.id, customer_id: @c1.id, status: 2, created_at: '2012-03-27 14:54:09')
      @inv4 = Invoice.create!(merchant_id: @m1.id, customer_id: @c3.id, status: 2, created_at: '2012-02-28 14:54:09')
      @inv8 = Invoice.create!(merchant_id: @m2.id, customer_id: @c6.id, status: 1)
      
      @ii_1 = InvoiceItem.create!(invoice_id: @inv1.id, item_id: @i1.id, quantity: 10, unit_price: 10, status: 2)
      @ii_2 = InvoiceItem.create!(invoice_id: @inv1.id, item_id: @i2.id, quantity: 15, unit_price: 30, status: 0, created_at: "2012-03-28 14:54:09")
      @ii_3 = InvoiceItem.create!(invoice_id: @inv1.id, item_id: @i3.id, quantity: 5, unit_price: 5, status: 1, created_at: "2012-02-28 14:54:09")
      @ii_4 = InvoiceItem.create!(invoice_id: @inv4.id, item_id: @i3.id, quantity: 3, unit_price: 5, status: 1, created_at: "2012-04-28 14:54:09")
      
      @t1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @inv1.id)
      @t4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @inv4.id)
    end

    it 'incomplete_invoices' do
      expect(InvoiceItem.incomplete_invoices).to eq([@inv4, @inv1])
    end
  end

  describe 'instance methods' do
    before :each do 
      @m1 = Merchant.create!(name: 'Merchant 1')
      
      @d1 = @m1.bulk_discounts.create!(quantity: 15, discount: 5)
      @d2 = @m1.bulk_discounts.create!(quantity: 25, discount: 10)

      @c1 = Customer.create!(first_name: 'Yo', last_name: 'Yoz', address: '123 Heyyo', city: 'Whoville', state: 'CO', zip: 12345)
      
      @i1 = Invoice.create!(merchant_id: @m1.id, customer_id: @c1.id, status: 2, created_at: '2012-03-25 09:54:09')
      
      @item_2 = @m1.items.create!(name: 'rest', description: 'dont test me', unit_price: 12)
      
      @ii_1 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_2.id, quantity: 30, unit_price: 12, status: 2)
      @ii_2 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_2.id, quantity: 15, unit_price: 12, status: 2)
      @ii_3 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_2.id, quantity: 2, unit_price: 12, status: 2)
      
      @t1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @i1.id)
    end

    describe '#find_discount' do
      it 'should return a discount if criteria is met' do
        expect(@ii_2.find_discount).to eq(@d1)
      end

      it 'should return the best discount if multiple discounts requirements are met' do
        expect(@ii_1.find_discount).to eq(@d2)
      end

      it 'should return nil if no criteria is met' do
        expect(@ii_3.find_discount).to eq(nil)
      end
    end

    describe '#new_unit_price' do
      it 'should apply an update to the InvoiceItem unit_price if a discount is met' do
        @ii_2.new_unit_price
        expect(@ii_2.unit_price).to eq(11.4)
      end
    end
  end
    
 
end
