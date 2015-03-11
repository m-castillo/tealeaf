require 'rubygems'
require 'sinatra'
require 'pry'

use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :secret => 'hakuna matata' 

get '/' do
  "Hello people!"
end

get "/template" do
  erb :mytemplate
end

get "/nothere" do
  redirect "/"
end

get "/form" do
  erb :form
end

post "/myaction" do
  puts params["username"]
end

get "/example" do
  "This is an example of a rendered text... Yippie!"
end

get "/nested_template" do
  erb :"/users/profile"
end

get "/mcastillo" do
  erb :mcastillo
end

get "/mcastillo_nested" do
  erb :"/users/mcastillo2"
end


