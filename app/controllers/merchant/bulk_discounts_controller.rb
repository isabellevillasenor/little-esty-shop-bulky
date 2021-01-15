class Merchant::BulkDiscountsController < ApplicationController
  def index
    @discounts = BulkDiscount.all
  end
  
  def show

  end

  def new
    find_merchant
  end

  def create
    # require 'pry'; binding.pry
    BulkDiscount.create!(bulk_discount_params_create)
    flash.notice = 'Discount Has Been Created!'
    redirect_to merchant_dashboard_index_path(params[:merchant_id])
  end

  private
  def bulk_discount_params_create
    params.permit(:percentage_discount, :quantity_threshold, :merchant_id, :item_id)
  end

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def find_item
    @item = Item.find(params[:item_id])
  end
end