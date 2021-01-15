class Merchant::ItemsController < ApplicationController
  before_action :find_item, only: [:show, :edit, :update]
  before_action :find_merchant

  def index
    @enabled_items = @merchant.items.enabled
    @disabled_items = @merchant.items.disabled
  end

  def show

  end

  def edit

  end

  def update
    if @item.update(item_params)
      flash.notice = "Succesfully Updated Item Info!"
      redirect_to merchant_item_path(@merchant, @item)
    else
      flash.notice = "All fields must be completed, get your act together."
      redirect_to edit_merchant_item_path(@merchant, @item)
    end
  end

  def new

  end

  def create
    @merchant.items.create!(item_params_create)
    flash.notice = 'Item Has Been Created!'
    redirect_to merchant_items_path(@merchant)
  end

  private
  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end

  def item_params_create
    params.permit(:name, :description, :unit_price, :merchant_id)
  end

  def find_item
    @item = Item.find(params[:id])
  end

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end


