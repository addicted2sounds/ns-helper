require 'spec_helper'

require 'shop_helper'

describe Clerk::Manager do

  let(:helper) { ShopHelper.new :saveur_shop, :dev }
  let(:role) { :clerk }
  let(:manager) { helper.send role }


  it 'clerk should return Clerk::Manager' do
    expect(manager).to be_a_kind_of Clerk::Manager
  end

  it 'should login successfully' do
    expect(manager.login).to be_truthy
  end

  it 'existing site should be selected' do
    manager.set_site 'Test'
  end

  it 'should edit existing template' do

  end
end