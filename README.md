tumblr-photo-export
=============

Export the images from your [liked posts](https://www.tumblr.com/likes) in Tumblr.

## How to use it

1. Clone the repo:  

        $ git clone git@github.com:javierarce/tumblr-photo-export.git

2. Enable the option "Share posts you like" in the settings page of your blog (e.g.: https://www.tumblr.com/settings/blog/javierarce)
 
3. Register a new app:  

        https://www.tumblr.com/settings/apps

4. Copy the `OAuth Consumer Key` of the app.  
5. Add two keys to your bash/zsh:  

        export TUMBLR_USERNAME="MY_FANTASTIC_TUMBLR_USERNAME"  
        export TUMBLR_API_KEY="MY_DAUNTING_OAUTH_CONSUMER_KEY"  
        
        
Or simply update the `export.rb` file with your details:
        
        # Configuration
        username = "MY_COOL_TUMBLR_USERNAME"
        api_key  = "MY_OH_SO_NICE_OAUTH_CONSUMER_KEY"  

6. Go to the app directory and run:  

        ruby export.rb

7. Your favorite images from Tumblr will be downloaded to the `image` folder.

You can specify two params (`username` & `name` of the download directory) directly from the command line like this:

         ruby export.rb username download_dir


## Contributors

[Javier Arce](https://github.com/javierarce)  
[Sergi Meseguer](https://github.com/zigotica)

## More

Hey there, digital Diogenes, do you need to export more? Then check out the [tumblr-full-backup](https://github.com/zigotica/tumblr-full-backup) repo by [zigotica](https://github.com/zigotica).
