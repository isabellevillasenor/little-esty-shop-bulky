class Merchant::BulkDiscountsController < ApplicationController
  before_action :set_merchant, only: [:index, :new, :create, :destroy]
  def index
    @discounts = @merchant.bulk_discounts
  end

  def show
    
  end

  def new
  end

  def create
    BulkDiscount.create!(discount_params)
    flash.notice = 'Your New Discount Has Been Created!'
    redirect_to merchant_bulk_discounts_path(@merchant)
  end
  
  def destroy
    BulkDiscount.destroy(params[:id])
    flash.notice = 'Discount Has Been Deleted!'
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  private
  def set_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
  
  def discount_params
    params.permit(:discount, :quantity, :merchant_id)
  end
end