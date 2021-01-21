require 'rails_helper'
include ActionView::Helpers::NumberHelper

describe 'Admin Invoices Index Page' do
  before :each do
    @m1 = Merchant.create!(name: 'Merchant 1')

    @d1 = @m1.bulk_discounts.create!(discount: 15.0, quantity:10)
    @d2 = @m1.bulk_discounts.create!(discount: 20.0, quantity:30)

    @c1 = Customer.create!(first_name: 'Yo', last_name: 'Yoz', address: '123 Heyyo', city: 'Whoville', state: 'CO', zip: 12345)
    @c2 = Customer.create!(first_name: 'Hey', last_name: 'Heyz', address: '456 Byye', city: 'Right Here', state: 'CO', zip: 98765)

    @inv1 = Invoice.create!(merchant_id: @m1.id, customer_id: @c1.id, status: 2, created_at: '2012-03-25 09:54:09')
    @inv2 = Invoice.create!(merchant_id: @m1.id, customer_id: @c2.id, status: 1, created_at: '2012-03-25 09:30:09')

    @item_1 = @m1.items.create!(name: 'test', description: 'lalala', unit_price: 6)
    @item_2 = @m1.items.create!(name: 'rest', description: 'dont test me', unit_price: 12)
   
    @ii_1 = InvoiceItem.create!(invoice_id: @inv1.id, item_id: @item_1.id, quantity: 12, unit_price: 6, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @inv1.id, item_id: @item_2.id, quantity: 6, unit_price: 12, status: 1)
    @ii_3 = InvoiceItem.create!(invoice_id: @inv2.id, item_id: @item_2.id, quantity: 87, unit_price: 12, status: 2)

    @t1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @inv1.id)

    visit admin_invoice_path(@inv1)
  end

  it 'should display the id, status and created_at' do
    expect(page).to have_content("Invoice ##{@inv1.id}")
    expect(page).to have_content("Created on: #{@inv1.created_at.strftime("%A, %B %d, %Y")}")

    expect(page).to_not have_content("Invoice ##{@inv2.id}")
  end

  it 'should display the customers name and shipping address' do
    expect(page).to have_content("#{@c1.first_name} #{@c1.last_name}")
    expect(page).to have_content(@c1.address)
    expect(page).to have_content("#{@c1.city}, #{@c1.state} #{@c1.zip}")

    expect(page).to_not have_content("#{@c2.first_name} #{@c2.last_name}")
  end

  it 'should display all the items on the invoice' do
      expect(page).to have_content(@item_1.name)
      expect(page).to have_content(@item_2.name)

      expect(page).to have_content(@ii_1.quantity)
      expect(page).to have_content(@ii_2.quantity)

      expect(page).to have_content("$#{@ii_2.unit_price}")

      expect(page).to have_content(@ii_1.status)
      expect(page).to have_content(@ii_2.status)

      expect(page).to_not have_content(@ii_3.quantity)
      expect(page).to_not have_content(@ii_3.status)
  end

  it 'should have status as a select field that updates the invoices status' do
    within("#status-update-#{@inv1.id}") do
      select('cancelled', :from => 'invoice[status]')
      expect(page).to have_button('Update Invoice')
      click_button 'Update Invoice'

      expect(current_path).to eq(admin_invoice_path(@inv1))
      expect(@inv1.status).to eq('complete')
    end
  end

  it 'should display the total revenue of the invoice before and after discount' do
    within("#revenue-info-#{@inv1.id}") do
      expect(page).to have_content('Total Revenue Before Discount: 144.0')
      expect(page).to have_content('Total Revenue After Discount: 133.2')
    end
  end
end

