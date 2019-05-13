Tumblr Liked Photos Export
==========================

Export the images from your [liked posts](https://www.tumblr.com/likes) in Tumblr.

## Installation

1. Clone the repo:  

        $ git clone git@github.com:javierarce/tumblr-liked-photos-export.git

2. Install dependencies:

        $ gem install httparty

3. Enable the option "Share posts you like" in the settings page of your blog.
 
4. Register a new app:  

        https://www.tumblr.com/oauth/apps

5. Copy the `OAuth Consumer Key` of the app.  
6. Add two keys to your bash/zsh…  

        export TUMBLR_USERNAME="MY_FANTASTIC_TUMBLR_USERNAME"  
        export TUMBLR_API_KEY="MY_DAUNTING_OAUTH_CONSUMER_KEY"  
               
7. … or simply update the `export.rb` file with your credentials:
        
        # Configuration
        username = "MY_COOL_TUMBLR_USERNAME"
        api_key  = "MY_OH_SO_NICE_OAUTH_CONSUMER_KEY"

## Usage

Go to the app directory and run:  

    ruby export.rb

Your favorite images from Tumblr will be downloaded to the folder `images`.

Optionally, you can specify a `username` param:

    ruby export.rb username

Or a `username` and a `name` for the download directory:

    ruby export.rb username download_dir

## Output

This is what it looks like when it runs:

```
$ ruby export.rb username

URL
http://api.tumblr.com/v2/blog/username.tumblr.com/likes?api_key=API_KEY

USERNAME
username

DIR
images

Downloading 1234 posts

blog-a
   https://66.media.tumblr.com/8262342342318fcaaae94770923093/tumblr_klmsadflkldsk1_500.jpg
blog-b
   https://66.media.tumblr.com/8262342342318fcaaae94770923093/tumblr_klmsadflkldsk1_500.jpg
   https://66.media.tumblr.com/8262342342318fcaaae94770923093/tumblr_klmsadflkldsk1_500.jpg
blog-c
  https://66.media.tumblr.com/8262342342318fcaaae94770923093/tumblr_klmsadflkldsk1_500.jpg
...
```

## Troubleshooting

- If you get the an `Unauthorized` error message, open the URL http://api.tumblr.com/v2/blog/USERNAME.tumblr.com/likes?api_key=API_KEY in your browser (replacing USERNAME and API_KEY with your own values). You should see a list of posts.

- If you get the error `cannot load such file -- httparty`, use `gem` to install dependencies.

## Contributors

[Javier Arce](https://github.com/javierarce)  
[Sergi Meseguer](https://github.com/zigotica)

## More

Hey there, digital Diogenes, do you need to export more? Then check out the [tumblr-full-backup](https://github.com/zigotica/tumblr-full-backup) repo by [zigotica](https://github.com/zigotica).
