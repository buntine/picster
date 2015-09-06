require "sinatra"
require "open-uri"
require "json"
require "./partials"

helpers Sinatra::Partials

def random_pic(subreddit)
  tries = 0

  begin
    uri = URI.parse("http://api.reddit.com/r/#{subreddit}/random")
    resp = JSON.parse(uri.read)
    pic = resp[0]["data"]["children"][0]["data"]["url"]

    if pic and ["gif", "jpg", "png"].include?(pic[-3, 3].downcase)
      return pic
    else
      raise RuntimeError
    end
  rescue
    tries += 1

    if tries <= 3
      retry
    else
      return "http://farm9.staticflickr.com/8100/8611569448_2fb4be9923_z.jpg"
    end
  end
end

def send_email(email, url)
end

get "/" do
  erb :index
end

post "/" do
  email = params["email"]
  url = random_pic("monkslookingatbeer")

  send_email(email, url)

  erb :done, :locals => {:url => url}
end
