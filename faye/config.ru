$stdout.sync = true

if defined?(PhusionPassenger)
  PhusionPassenger.advertised_concurrency_level = 0
end

require 'faye'
Faye::WebSocket.load_adapter('thin') unless ENV['RACK_ENV'] == 'production'
app = Faye::RackAdapter.new(:mount => '/faye', :timeout => 25)
run app
