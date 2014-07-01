tumblr-export
=============

Export tumblr images from your [liked posts](https://www.tumblr.com/likes).

## How to use it


1. Clone the repo:  

        $ git clone git@github.com:javierarce/tumblr-photo-export.git

2. Register a new app:  

        https://www.tumblr.com/settings/apps

3. Copy the `OAuth Consumer Key` of the app.  
4. Add two keys to your bash/zsh:  

        export TUMBLR_USERNAME="MY_FANTASTIC_TUMBLR_USERNAME"  
        export TUMBLR_API_KEY="MY_DAUNTING_OAUTH_CONSUMER_KEY"  
        
        
5. Or simply update the `export.rb` file with your details:
        
        # Configuration
        username = "MY_COOL_TUMBLR_USERNAME"
        api_key  = "MY_OH_SO_NICE_OAUTH_CONSUMER_KEY"  

6. Go to the app directory and run:  

        ruby app.rb
 


        
