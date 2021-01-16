require 'rails_helper'

describe BulkDiscount do 
  describe 'validations' do
    it { should validate_numericality_of(:quantity).is_greater_than(0) }
    it { should validate_numericality_of(:discount).is_greater_than(0) }
    it { should validate_numericality_of(:discount).is_less_than(100) }
  end

  describe 'relationships' do
    it { should belong_to :merchant }
  end
end