require "sinatra"
require "./partials"

helpers Sinatra::Partials

def random_pic(subreddit)
  "http://i.imgur.com/nTBBwgs.jpg"
end

def send_email(email, url)
end

get "/" do
  erb :index
end

post "/" do
  email = params["email"]
  url = random_pic("radpics")

  send_email(email, url)

  erb :done, :locals => {:url => url}
end
