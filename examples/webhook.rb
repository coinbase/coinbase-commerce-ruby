# Sinatra server example to test webhooks
# You may need tunnels to localhost webhook development tool and debugging tool.
# f.e. you could try ngrok

require 'sinatra'
require 'coinbase_commerce'

set :port, 5000
WEBHOOK_SECRET = 'your_webhook_secret'

# Using Sinatra
post '/webhooks' do
  payload = request.body.read
  sig_header = request.env['HTTP_X_CC_WEBHOOK_SIGNATURE']

  begin
    event = CoinbaseCommerce::Webhook.construct_event(payload, sig_header, WEBHOOK_SECRET)
    # event handle
    puts "Received event id=#{event.id}, type=#{event.type}"
    status 200
  # errors handle
  rescue JSON::ParserError => e
    puts "json parse error"
    status 400
    return
  rescue CoinbaseCommerce::Errors::SignatureVerificationError => e
    puts "signature verification error"
    status 400
    return
  rescue CoinbaseCommerce::Errors::WebhookInvalidPayload => e
    puts "missing request or headers data"
    status 400
    return
  end
end
