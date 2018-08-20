require 'spec_helper'

describe CoinbaseCommerce::APIResources::Base::APIResource do
  before :all do
    @client = CoinbaseCommerce::Client.new(api_key: 'api_key')
    @api_base = @client.instance_variable_get :@api_uri
  end

  it "shout create a new APIResource without request" do
    CoinbaseCommerce::APIResources::Base::APIResource.new("id")
    assert_not_requested :get, %r{#{@api_base}/.*}
  end

  it "should create APIResource object form hash without request" do
    CoinbaseCommerce::APIResources::Base::APIResource.create_from(id: "some_id",
                                                                  param: {id: "param_id"})
    assert_not_requested :get, %r{#{@api_base}/.*}
  end

  it "setting an attribute should not cause a network request" do
    c = CoinbaseCommerce::APIResources::Base::APIResource.new("cus_123")
    c.param = {id: "param_id"}
    assert_not_requested :get, %r{#{@api_base}/.*}
    assert_not_requested :post, %r{#{@api_base}/.*}
  end

  it "accessing id should not issue a fetch" do
    c = CoinbaseCommerce::APIResources::Base::APIResource.new("cus_123")
    c.id
    assert_not_requested :get, %r{#{@api_base}/.*}
  end
end
