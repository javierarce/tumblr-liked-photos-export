require 'rubygems'
require 'httparty'
require 'byebug'

# Configuration
api_key      = ENV['TUMBLR_API_KEY']
username     = ENV['TUMBLR_USERNAME']
image_dir    = ARGV[1] || username
download_num = 2000 # number of posts to download

class TumblrPhotoExport

  attr_accessor :username, :api_key, :image_dir, :limit, :download_num, :url

  def initialize(username, api_key, image_dir, download_num)

    @username     = username
    @api_key      = api_key
    @image_dir    = image_dir
    @limit        = 20
    @download_num = download_num
    @i = 0

    @url          = "http://api.tumblr.com/v2/blog/#{@username}.tumblr.com/posts/photo?api_key=#{@api_key}"

    create_download_dir
  end

  def create_download_dir
    Dir.mkdir("./#{@image_dir}") unless File.directory?("./#{@image_dir}")
  end

  def get_liked_count
    response        = HTTParty.get(@url + "&limit=1&offset=0")
    parsed_response = JSON.parse(response.body)

    return parsed_response['response']['total_posts']
  end

  def get_photos(limit = 0, timestamp)

    url = @url + "&limit=20&before=#{timestamp}"
    response        = HTTParty.get(url)

    puts url

    parsed_response = JSON.parse(response.body)

    # Status of the request
    status_code = parsed_response['meta']['status']
    status_msg  = parsed_response['meta']['msg']

    if status_code != 200
      puts "#{status_msg}"
      return
    end

    download_likes(parsed_response['response']['posts'])
  end

  def download_likes(likes)

    likes.each do |like|

      photos = like['photos']

      photos.each do |photo|

        begin

          uri = photo['original_size']['url']
          file = File.basename(uri)
          ext = File.extname(file)
          filepath = "./#{@image_dir}/#{file}"
          @i  = @i + 1

          File.open(filepath, "wb") do |f| 
            puts "[#{@download_num - @i}] #{uri} - #{like['blog_name']} #{like['liked_timestamp']}"
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
    @download_num = get_liked_count

    parsed = 0

    rest = @download_num % @limit

    if rest > 1
      rest = 1
    end

    batchs = (@download_num / @limit) + rest

    if @download_num < @limit
      batchs = 1
      @limit  = @download_num
    end

    puts "Downloading #{@download_num} posts\r"

    results = nil

    batchs.times do |i|
      if results
        timestamp = results[results.length - 1]["timestamp"]
      else
        timestamp = nil
      end

      if parsed + @limit > @download_num
        @limit = @download_num - parsed
      end

      results = get_photos(@limit, timestamp)
      puts results.length
      parsed += @limit
      break if !results
    end

    puts "#{"Aaaaand we're done, parsed #{parsed} "}"

  end

end

tumblr = TumblrPhotoExport.new(username, api_key, image_dir, download_num)
tumblr.download
