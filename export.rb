require 'rubygems'
require 'httparty'

# Configuration
api_key      = ENV["TUMBLR_API_KEY"]
username     = ARGV[0] || ENV["TUMBLR_USERNAME"]
image_dir    = ARGV[1] || "images"
limit        = 20  # number of posts requested each time
download_num = 200 # number of posts to download

class Tumblr

  attr_accessor :username, :api_key, :image_dir, :limit, :download_num, :url

  def initialize(username, api_key, image_dir, limit, download_num)

    @username     = username
    @api_key      = api_key
    @image_dir    = image_dir
    @limit        = limit
    @download_num = download_num

    @url          = "http://api.tumblr.com/v2/blog/#{@username}.tumblr.com/likes?api_key=#{@api_key}"

    create_download_dir

  end

  def create_download_dir

    Dir.mkdir("./#{@image_dir}") unless File.directory?("./#{@image_dir}")

  end

  def get_liked_count

    response        = HTTParty.get(@url + "&limit=1&offset=0")
    parsed_response = JSON.parse(response.body)

    return parsed_response['response']['liked_count']

  end

  def get_photos(limit = 0, offset = 0)

    response        = HTTParty.get(@url + "&limit=#{limit}&offset=#{offset}")
    parsed_response = JSON.parse(response.body)

    # Status of the request
    status_code = parsed_response['meta']['status']
    status_msg  = parsed_response['meta']['msg']

    if status_code != 200
      puts status_msg
      return
    end

    download_likes(parsed_response['response']['liked_posts'])

    return true

  end

  def download_likes(likes)

    likes.each do |like|

      photos = like['photos']

      puts "\033[37m#{like['blog_name']}\033[0m" if photos and photos.length > 0

      photos.each do |photo|

        begin

          uri = photo['original_size']['url']
          file = File.basename(uri)

          File.open("./#{@image_dir}/" + file, "wb") do |f| 
            puts "   #{uri}"
            f.write HTTParty.get(uri).parsed_response
          end

        rescue => e
          puts ":( #{e}"
        end

      end if photos
    end

  end

  def download

    # uncomment next line to download all your liked images
    # download_num = get_liked_count

    batchs = download_num / limit

    puts "Downloading \033[32m#{@download_num}\033[0m posts"

    batchs.times do |i|
      result = get_photos(limit, i + i*limit) 
      break if !result
    end
  end

end

tumblr = Tumblr.new(username, api_key, image_dir, limit, download_num)
tumblr.download
