require 'rails_helper'

describe 'Merchant Discount Show Page' do
  before :each do 
    @m1 = Merchant.create!(name: 'Merchant 1')
    @m2 = Merchant.create!(name: 'Merchant 2')

    @d1 = @m1.bulk_discounts.create!(discount: 15.0, quantity:10)
    @d2 = @m1.bulk_discounts.create!(discount: 20.0, quantity:30)

    @d3 = @m2.bulk_discounts.create!(discount: 7.0, quantity:15)
    @d4 = @m2.bulk_discounts.create!(discount: 10.0, quantity:50)
    visit merchant_bulk_discount_path(@m1, @d1)
  end

  it 'should show the discounts quantity and discount percentage' do
    expect(page).to have_content(@d1.quantity)
    expect(page).to have_content(@d1.discount)

    expect(page).to_not have_content(@d2.discount)
  end

  it 'should have a link to edit the discount' do
    expect(page).to have_link('Edit This Discount')
    click_link 'Edit This Discount'
    
    expect(current_path).to eq(edit_merchant_bulk_discount_path(@m1, @d1))
  end
end