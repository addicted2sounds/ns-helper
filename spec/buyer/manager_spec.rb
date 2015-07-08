require 'spec_helper'

require 'shop_helper'

describe Buyer::Manager do

  let(:helper) { ShopHelper.new :saveur_shop, :dev }
  let(:role) { :buyer }
  let(:manager) { helper.send role }


  it 'clerk should return Buyer::Manager' do
    expect(manager).to be_a_kind_of Buyer::Manager
  end

  it 'purchase product' do
    manager.purchase '/homeware/kitchen/anderson-ernser/homeware-product_6251453'
  end
end