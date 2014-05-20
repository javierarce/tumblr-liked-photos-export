require 'rubygems'
require 'httparty'

# Configuration
username = "YOUR_TUMBLR_USERNAME"
api_key  = "YOUR_TUMBLR_API_KEY"
limit    = 20

url      = "http://api.tumblr.com/v2/blog/#{username}.tumblr.com/likes?api_key=#{api_key}"

def get_liked_count(url)

  response        = HTTParty.get(url + "&limit=1&offset=0")
  parsed_response = JSON.parse(response.body)

  return parsed_response['response']['liked_count']

end

def get_photos(url, limit = 0, offset = 0)

  urls = []

  response = HTTParty.get(url + "&limit=#{limit}&offset=#{offset}")
  parsed_response = JSON.parse(response.body)

  likes = parsed_response['response']['liked_posts']

  parsed_response = JSON.parse(response.body)

  likes.each do |like|

    photos = like['photos']

    photos.each do |photo|

      begin

        uri = photo['original_size']['url']
        file = File.basename(uri)

        File.open("./images/" + file, "wb") do |f| 
          puts uri
          f.write HTTParty.get(uri).parsed_response
        end

      rescue => e
        puts ":( #{e}"
      end

    end if photos

  end

end

download_count = 200 # or get_liked_count(url) to download everything

Dir.mkdir("./images") unless File.directory?("./images")

batchs = download_count / limit

urls = []

puts "Getting #{download_count} posts"

batchs.times do |i|
  get_photos(url, limit, i + i*limit)
end
