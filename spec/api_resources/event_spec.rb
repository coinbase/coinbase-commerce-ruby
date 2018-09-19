describe CoinbaseCommerce::APIResources::Event do
  before :all do
    @client = CoinbaseCommerce::Client.new(api_key: 'api_key')
    @api_base = @client.instance_variable_get :@api_uri
  end

  it "making a GET request with parameters should have a query string and no body" do
    stub_request(:get, "#{@api_base}#{CoinbaseCommerce::APIResources::Event::RESOURCE_PATH}")
        .with(query: {limit: 5}).to_return(body: JSON.generate(data: [mock_list]))
    @client.event.list(limit: 5)
  end
end
