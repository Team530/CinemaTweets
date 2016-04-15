twitter = Twitter::REST::Client.new do |config|
  config.consumer_key = 'EmK9czXCnYHya9ZK4bHrKdM6zu'
  config.consumer_secret = 'bE2C2VWxXBwsGdzGaW07lsaOp559BVZKfMe2av5VBXnlLOHNfL'

  config.access_token = ENV['YOUR_ACCESS_TOKEN']
  config.access_token_secret = ENV['YOUR_ACCESS_SECRET']
end