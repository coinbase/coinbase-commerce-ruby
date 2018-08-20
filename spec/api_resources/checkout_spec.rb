describe CoinbaseCommerce::APIResources::Checkout do
  before :all do
    @client = CoinbaseCommerce::Client.new(api_key: 'api_key')
    @api_base = @client.instance_variable_get :@api_uri
  end

  it "checkout should save nothing if nothing changes" do
    stub_request(:post, "#{@api_base}#{CoinbaseCommerce::APIResources::Checkout::RESOURCE_PATH}")
        .to_return(body: {data: {id: "id_value", key: "key_value"}}.to_json)
    checkout = @client.checkout.create(id: "id_value", key: "key_value")

    stub_request(:put, "#{@api_base}#{CoinbaseCommerce::APIResources::Checkout::RESOURCE_PATH}/id_value")
        .with(body: {})
        .to_return(body: JSON.generate("id" => "id_value", "key" => "key_value"))

    checkout.save
  end

  it "making a POST request with parameters should have a body and no query string" do
    stub_request(:post, "#{@api_base}#{CoinbaseCommerce::APIResources::Checkout::RESOURCE_PATH}")
        .with(body: {:id => "id_value", :key => "key_value"})
        .to_return(body: {data: {id: "id_value", key: "key_value"}}.to_json)
    @client.checkout.create(id: "id_value", key: "key_value")
  end

  it "making a GET request with parameters should have a query string and no body" do
    stub_request(:get, "#{@api_base}#{CoinbaseCommerce::APIResources::Checkout::RESOURCE_PATH}")
        .with(query: {limit: 5}).to_return(body: JSON.generate(data: [mock_list]))
    @client.checkout.list(limit: 5)
  end
end
