require 'rails_helper'

describe 'Merchant New Bulk Discount' do
  before :each do
    @m1 = Merchant.create!(name: 'Merchant 1')
    visit new_merchant_bulk_discount_path(@m1)
  end
  
  it 'should be able to fill in a form and create a new bulk discount for that merchant' do
    fill_in :discount, with: 5.0
    fill_in :quantity, with: 20

    click_button

    expect(current_path).to eq(merchant_bulk_discounts_path(@m1))
    expect(page).to have_link('Discount: 5.0%')
    expect(page).to have_content('off of 20 items or more.')
  end
end
