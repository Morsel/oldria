require 'netrecorder'

NetRecorder.config do |config|
  config.cache_file = "#{File.dirname(__FILE__)}/../fakeweb"
  if ENV['RECORD_WEB']
    config.record_net_calls = true
  else
    config.fakeweb = true
    # FakeWeb.allow_net_connect = false
  end
end
