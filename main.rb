require "sinatra"
require "open-uri"
require "json"
require "mandrill"
require "./partials"

helpers Sinatra::Partials

def conf
  {extensions: ["gif", "jpg", "png"],
   subreddits: {"beer" => "monkslookingatbeer",
                "dudes" => "ladyboners",
                "rad" => "radpics"},
   mandrill_key: File.read("mandrill.txt").chomp,
   default: "http://farm9.staticflickr.com/8100/8611569448_2fb4be9923_z.jpg"}
end

def random_pic(subreddit)
  tries = 0

  begin
    uri = URI.parse("http://api.reddit.com/r/#{subreddit}/random")
    resp = JSON.parse(uri.read)
    pic = resp[0]["data"]["children"][0]["data"]["url"]

    if pic and conf[:extensions].include?(pic[-3, 3].downcase)
      return pic
    else
      raise RuntimeError
    end
  rescue
    tries += 1

    if tries <= 3
      retry
    else
      return conf[:default]
    end
  end
end

def send_email(email, url)
  mandrill = Mandrill::API.new(conf[:mandrill_key])

  config = {
    :subject => "Your Daily Picster",
    :from_email => "hello@picster.io",
    :from_name => "Picster",
    :to => [{
      :email => email,
      :name => email
    }],
    :global_merge_vars => [{
      :name => "IMGURL",
      :content => url
    }]
  }

  mandrill.messages.send_template("Picster", {}, config)
end

get "/" do
    puts conf[:subreddit]
  erb :index
end

post "/" do
  email = params["email"]
  subreddit = conf[:subreddits][params["interest"]]
  url = random_pic(subreddit)

  #send_email(email, url)

  erb :done, :locals => {:url => url}
end
