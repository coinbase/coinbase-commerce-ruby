require 'coinbase_commerce'

client = CoinbaseCommerce::Client.new(api_key: 'your_api_key')

# create checkout
data = {
    "name": "The Sovereign Individual",
    "description": "Mastering the Transition to the Information Age",
    "pricing_type": "fixed_price",
    "local_price": {
        "amount": "1.00",
        "currency": "USD"
    },
    "requested_info": ["name", "email"]
}
checkout = client.checkout.create(data)

# or retrieve it if you know checkout id
checkout = client.checkout.retrieve checkout.id

# update checkout with modify method
upd_checkout = client.checkout.modify(checkout.id, "local_price": {
    "amount": "10000.00",
    "currency": "USD"
})

# or with save method if you already have checkout object
upd_checkout.name
upd_checkout.description = "foo"
upd_checkout.to_hash
upd_checkout.name = "bar"
amount = "1000.00"
upd_checkout.local_price.amount = amount
upd_checkout.save

# get checkouts list
checkouts_list = client.checkout.list

# in case you need provide additional params
checkouts_list = client.checkout.list(limit: 10)

# or get results from another page
checkouts_list = client.checkout.list(starting_after: checkout.id, limit: 3)

# checkout list could be iterated like
checkouts_list.data.each do |ch|
  # work with each checkout
  puts ch.id
end

# iterate over all checkouts and modify them with per-page limitation
client.checkout.auto_paging limit: 20 do |ch|
  puts ch.id
  ch.name = 'name updated'
  ch.save
  # also could be deleted by
  # ch.delete
end

# delete checkout
upd_checkout.delete
