require 'coinbase_commerce'

client = CoinbaseCommerce::Client.new(api_key: 'your_api_key')

# create charge
data = {
    "name": "The Sovereign Individual",
    "description": "Mastering the Transition to the Information Age",
    "local_price": {
        "amount": "100.00",
        "currency": "USD"
    },
    "pricing_type": "fixed_price"

}
charge = client.charge.create(data)

# or retrieve it if you know charge id
charge = client.charge.retrieve charge.id

# get charges list
charges_list = client.charge.list

# in case you need provide additional params
charges_list = client.charge.list(limit: 10)

# or get results from another page
charges_list = client.charge.list(starting_after: charge.id, limit: 3)

# charges list could be iterated like
charges_list.data.each do |charge|
  puts charge.id
end

# iterate over all charges with per-page limitation
client.charge.auto_paging limit: 20 do |charge|
  puts charge.id
end
