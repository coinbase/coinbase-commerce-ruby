# frozen_string_literal: true
require 'spec_helper'

describe CoinbaseCommerce do
  before :all do
    @client = CoinbaseCommerce::Client.new(api_key: 'api_key')
    @api_base = @client.instance_variable_get :@api_uri
  end

  # test list resources
  it "should get charges" do
    stub_request(:get, "#{@api_base}charges").to_return(body: mock_list.to_json)
    charge_list = @client.charge.list
    expect(charge_list).is_a? @client.charge
    expect(charge_list.data).is_a? Array
    expect(charge_list.pagination).is_a? CoinbaseCommerce::APIResources::Base::APIObject
    expect(charge_list.data[0].to_hash).to eq mock_item
  end

  it "should get checkouts" do
    stub_request(:get, "#{@api_base}checkouts").to_return(body: mock_list.to_json)
    checkout_list = @client.checkout.list
    expect(checkout_list).is_a? @client.checkout
    expect(checkout_list.data).is_a? Array
    expect(checkout_list.pagination).is_a? CoinbaseCommerce::APIResources::Base::APIObject
    expect(checkout_list.data[0].to_hash).to eq mock_item
  end

  it "should should get events" do
    stub_request(:get, "#{@api_base}events").to_return(body: mock_list.to_json)
    event_list = @client.event.list
    expect(event_list).is_a? @client.checkout
    expect(event_list.data).is_a? Array
    expect(event_list.pagination).is_a? CoinbaseCommerce::APIResources::Base::APIObject
    expect(event_list.data[0].to_hash).to eq mock_item
  end


  # test single resources
  it "should get charge" do
    stub_request(:get, "#{@api_base}charges/key").to_return(body: {data: mock_item}.to_json)
    charge = @client.charge.retrieve :key
    expect(charge).is_a? @client.charge
    expect(charge).is_a? CoinbaseCommerce::APIResources::Base::APIObject
    expect(charge.id).to eq mock_item[:id]
    expect(charge.key).to eq mock_item[:key]
  end

  it "should get checkout" do
    stub_request(:get, "#{@api_base}checkouts/key").to_return(body: {data: mock_item}.to_json)
    checkout = @client.checkout.retrieve :key
    expect(checkout).is_a? @client.checkout
    expect(checkout).is_a? CoinbaseCommerce::APIResources::Base::APIObject
    expect(checkout.id).to eq mock_item[:id]
    expect(checkout.key).to eq mock_item[:key]
  end

  it "should get event" do
    stub_request(:get, "#{@api_base}events/key").to_return(body: {data: mock_item}.to_json)
    event = @client.event.retrieve :key
    expect(event).is_a? @client.charge
    expect(event).is_a? CoinbaseCommerce::APIResources::Base::APIObject
    expect(event.id).to eq mock_item[:id]
    expect(event.key).to eq mock_item[:key]
  end

  # test create resources
  it "should create charge" do
    stub_request(:post, "#{@api_base}charges").to_return(body: {data: mock_item}.to_json)
    charge = @client.charge.create(mock_item)
    expect(charge).is_a? @client.charge
    expect(charge).is_a? CoinbaseCommerce::APIResources::Base::APIObject
    expect(charge.id).to eq mock_item[:id]
    expect(charge.key).to eq mock_item[:key]
  end

  it "should create checkout" do
    stub_request(:post, "#{@api_base}checkouts").to_return(body: {data: mock_item}.to_json)
    checkout = @client.checkout.create(mock_item)
    expect(checkout).is_a? @client.checkout
    expect(checkout).is_a? CoinbaseCommerce::APIResources::Base::APIObject
    expect(checkout.id).to eq mock_item[:id]
    expect(checkout.key).to eq mock_item[:key]
  end

  # test delete resources
  it "should delete checkout" do
    stub_request(:post, "#{@api_base}checkouts").to_return(body: {data: mock_item}.to_json)
    stub_request(:delete, "#{@api_base}checkouts/val").to_return(body: {}.to_json)
    checkout = @client.checkout.create(mock_item)
    checkout.delete
  end

  # test save resources
  it "should save checkout" do
    stub_request(:post, "#{@api_base}checkouts").to_return(body: {data: mock_item}.to_json)
    stub_request(:put, "#{@api_base}checkouts/val").to_return(body: {:edited => true}.to_json)
    checkout = @client.checkout.create(mock_item)
    checkout.key = "new value"
    checkout.save
    expect(checkout.edited).to eq true
  end
end
