require "sinatra"
require "./partials"

helpers Sinatra::Partials

get "/" do
  erb :index
end

post "/" do
  erb :done
end
