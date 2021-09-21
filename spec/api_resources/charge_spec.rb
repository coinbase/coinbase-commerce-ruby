describe CoinbaseCommerce::APIResources::Charge do
  before :all do
    @client = CoinbaseCommerce::Client.new(api_key: 'api_key')
    @api_base = @client.instance_variable_get :@api_uri
  end

  it "making a POST request with parameters should have a body and no query string" do
    stub_request(:post, "#{@api_base}#{CoinbaseCommerce::APIResources::Charge::RESOURCE_PATH}")
        .with(body: {:id => "id_value", :key => "key_value"})
        .to_return(body: {data: {id: "id_value", key: "key_value"}}.to_json)
    @client.charge.create(id: "id_value", key: "key_value")
  end

  it "making a GET request with parameters should have a query string and no body" do
    stub_request(:get, "#{@api_base}#{CoinbaseCommerce::APIResources::Charge::RESOURCE_PATH}")
        .with(query: {limit: 5}).to_return(body: JSON.generate(data: [mock_list]))
    @client.charge.list(limit: 5)
  end

  it 'resolves a charge' do
    stub_request(:post, "#{@api_base}#{CoinbaseCommerce::APIResources::Charge::RESOURCE_PATH}")
        .with(body: {:id => "id_value", :key => "key_value"})
        .to_return(body: {data: {id: "id_value", key: "key_value"}}.to_json)
    charge = @client.charge.create(id: "id_value", key: "key_value")
    stub_request(:post, "#{@api_base}#{CoinbaseCommerce::APIResources::Charge::RESOURCE_PATH}/id_value/resolve")
        .with(body: {:id => "id_value", :key => "key_value"})
        .to_return(body: {data: {id: "id_value", key: "key_value"}}.to_json)
    charge.resolve
  end
end
