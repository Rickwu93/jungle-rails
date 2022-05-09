require 'rails_helper'

RSpec.describe Product, type: :model do

  before(:all) do
    @category = Category.find_or_create_by name: 'Evergreens'
    @product = @category.products.create({
      name: 'Purple Kush',
      description: "test",
      quantity: 10,
      price_cents: 69.99
    })
    end
  
    describe 'Validations' do
   
    it 'can create the product with 4 required parameters of name, price, quantity, category' do
      expect(@product.name).to be_present
      expect(@product.price).to be_present
      expect(@product.quantity).to be_present
      expect(@product.category).to be_present
    end

    it 'is not valid without a name and returns nil' do
      @product.name = nil
      @product.save
      expect(@product.name).to be(nil)
      expect(@product.errors.full_messages).to include "Name can't be blank"
    end

    it 'it is not valid without a price and returns nil' do
      @product.price_cents = nil
      @product.save
      expect(@product.price_cents).to be(nil)
      expect(@product.errors.full_messages).to include "Price can't be blank"
    end

    it 'it is not valid without a quantity and returns nil' do
      @product.quantity = nil
      @product.save
      expect(@product.quantity).to be(nil)
      expect(@product.errors.full_messages).to include "Quantity can't be blank"
    end

    it 'Category must be present and returns true' do
      expect(@product.category).to be_present
    end
  end
end