class Merchant::BulkDiscountsController < ApplicationController
  before_action :set_merchant
  before_action :set_discount, only: [:show, :edit, :update]
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

  def edit
  end

  def update
    if @discount.update(discount_params)
      flash.notice = 'Discount Has Been Updated!'
      redirect_to merchant_bulk_discount_path(@merchant, @discount)
    else
      flash.notice = 'All fields must be completed, get your act together.'
      redirect_to edit_merchant_bulk_discount_path(@merchant, @discount)
    end
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
  
  def set_discount
    @discount = BulkDiscount.find(params[:id])
  end

  def discount_params
    params.permit(:discount, :quantity, :merchant_id)
  end
end