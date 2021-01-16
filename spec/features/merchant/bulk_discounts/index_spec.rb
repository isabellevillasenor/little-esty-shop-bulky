require 'rails_helper'

describe 'Merchant Bulk Discount Dashboard' do
  before :each do
    @m1 = Merchant.create!(name: 'Merchant 1')
    @m2 = Merchant.create!(name: 'Merchant 2')

    @d1 = @m1.bulk_discounts.create!(discount: 15.0, quantity:10)
    @d2 = @m1.bulk_discounts.create!(discount: 20.0, quantity:30)

    @d3 = @m2.bulk_discounts.create!(discount: 7.0, quantity:15)
    @d4 = @m2.bulk_discounts.create!(discount: 10.0, quantity:50)
    visit merchant_bulk_discounts_path(@m1)
  end

  it 'should display a list of all that merchants discounts' do
    expect(page).to have_content("#{@m1.name}")
    expect(page).to have_content('My Discounts')
    expect(page).to have_content(@d1.discount)
    expect(page).to have_content(@d1.quantity)
    expect(page).to have_content(@d2.discount)
    expect(page).to have_content(@d2.quantity)

    expect(page).to_not have_content(@d3.discount)
  end

  it 'should have each discount link to its respective show page' do
    expect(page).to have_link(@d1.discount)
    click_link "#{@d1.discount}"

    expect(current_path).to eq(merchant_bulk_discount_path(@m1, @d1))
  end
end