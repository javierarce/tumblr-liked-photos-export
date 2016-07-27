require 'rubygems'
require 'httparty'

# Configuration
api_key      = ENV["TUMBLR_API_KEY"]
username     = ARGV[0] || ENV["TUMBLR_USERNAME"]
image_dir    = ARGV[1] || "images"
offset       = 0
limit        = 20  # number of posts requested each time
download_num = 500 # number of posts to download 

class TumblrPhotoExport

  attr_accessor :username, :api_key, :image_dir, :limit, :download_num, :url

  def initialize(username, api_key, image_dir, limit, offset, download_num)

    @username     = username
    @api_key      = api_key
    @image_dir    = image_dir
    @limit        = limit
    @offset       = offset
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
      puts "\033[91m#{status_msg}\033[0m" 
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
    # @download_num = get_liked_count

    parsed = 0

    rest = @download_num % @limit

    if rest > 1
      rest = 1
    end

    batchs = (@download_num / @limit) + rest

    if (@download_num < @limit)
      batchs = 1
      @limit  = @download_num
    end

    puts "Downloading \033[32m#{@download_num}\033[0m posts"

    batchs.times do |i|

      offset = @offset + i*@limit

      if parsed + @limit > @download_num
        @limit = @download_num - parsed
      end

      result = get_photos(@limit, offset)
      parsed += @limit
      break if !result

    end

    puts "\033[32m#{"Aaaaand we're done, parsed #{parsed} "}\033[0m"

  end

end

tumblr = TumblrPhotoExport.new(username, api_key, image_dir, limit, offset, download_num)
tumblr.download
