require 'coinbase_commerce'

client = CoinbaseCommerce::Client.new(api_key: 'your_api_key')

# get events list
events_list = client.event.list

# in case you need provide additional params
events_list = client.event.list(limit: 10)

# or get results from another page
event = events_list.data[0]
events_list = client.event.list(starting_after: event.id, limit: 3)

# event list could be iterated like
events_list.data.each do |event|
  puts event.id
end

# retrieve single event
event = client.event.retrieve event.id

# iterate over all events with per-page limitation
client.event.auto_paging limit: 20 do |event|
  puts event.id
end
