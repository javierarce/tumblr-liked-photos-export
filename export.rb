require 'rubygems'
require 'httparty'

# Configuration
username     = ENV["TUMBLR_USERNAME"]
api_key      = ENV["TUMBLR_API_KEY"]
image_dir    = "images" 
limit        = 20  # number of posts requested each time
download_num = 200 # number of posts to download

url          = "http://api.tumblr.com/v2/blog/#{username}.tumblr.com/likes?api_key=#{api_key}"

def get_liked_count(url)

  response        = HTTParty.get(url + "&limit=1&offset=0")
  parsed_response = JSON.parse(response.body)

  return parsed_response['response']['liked_count']

end

def get_photos(url, image_dir, limit = 0, offset = 0)

  urls = []

  response = HTTParty.get(url + "&limit=#{limit}&offset=#{offset}")
  parsed_response = JSON.parse(response.body)

  likes = parsed_response['response']['liked_posts']

  parsed_response = JSON.parse(response.body)

  likes.each do |like|

    photos = like['photos']

    puts "\033[37m#{like['blog_name']}\033[0m" if photos and photos.length > 0

    photos.each do |photo|

      begin

        uri = photo['original_size']['url']
        file = File.basename(uri)

        File.open("./#{image_dir}/" + file, "wb") do |f| 
          puts "   #{uri}"
          f.write HTTParty.get(uri).parsed_response
        end

      rescue => e
        puts ":( #{e}"
      end

    end if photos

  end

end

Dir.mkdir("./#{image_dir}") unless File.directory?("./#{image_dir}")

# uncomment next line to download all your liked images
# download_num = get_liked_count(url)

batchs = download_num / limit

urls = []

puts "Downloading \033[32m#{download_num}\033[0m posts"

batchs.times do |i|
  get_photos(url, image_dir, limit, i + i*limit)
end
