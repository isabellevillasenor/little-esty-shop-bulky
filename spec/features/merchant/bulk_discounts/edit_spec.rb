require 'rails_helper'

describe 'Merchant Discount Edit Page' do
  before :each do 
    @m1 = Merchant.create!(name: 'Merchant 1')
    @d1 = @m1.bulk_discounts.create!(discount: 15.0, quantity:10)
    visit edit_merchant_bulk_discount_path(@m1, @d1)
  end

  it 'should be able to fill in a form that updates the database' do
    fill_in :discount, with: 5.0
    fill_in :quantity, with: 20

    click_button

    expect(current_path).to eq(merchant_bulk_discount_path(@m1, @d1))
    expect(page).to have_content(5.0)
    expect(page).to have_content(20)
  end
end