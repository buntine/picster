require "sinatra"

get "/" do
  erb :index
end

post "/" do
  erb :done
end
