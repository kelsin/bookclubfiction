$stdout.sync = true

require 'faye'
Faye::WebSocket.load_adapter('thin') unless ENV['RACK_ENV'] == 'production'
app = Faye::RackAdapter.new(:mount => '/faye', :timeout => 25)
run app
