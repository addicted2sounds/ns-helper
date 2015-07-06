require 'spec_helper'

require 'shop_helper'

describe ShopHelper do

  let(:helper) { ShopHelper.new :saveur_shop, :dev }

  describe 'retailer' do
    let(:role) { :retailer }
    it 'clerk should return Retailer::Manager' do
      expect(helper.retailer).to be_a_kind_of Retailer::Manager
    end
  end

  describe 'clerk' do
    let(:role) { :clerk }
    let(:manager) { helper.send role }

    it 'clerk should return Clerk::Manager' do
      expect(manager).to be_a_kind_of Clerk::Manager
    end


  end
end