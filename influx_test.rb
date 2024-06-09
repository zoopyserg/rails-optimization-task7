require 'influxer'

Influxer.configure do |config|
  config.hosts = ['localhost']
  config.database = 'dx_metrics'
end

client = Influxer::Client.new
client.write_point('test_suite', values: { duration: 1 })

puts client.query('SELECT * FROM test_suite')
