require 'sinatra'
require 'sinatra/reloader' if development?
require_relative 'board.rb'

enable :sessions

get '/' do
  erb :index
end

post '/' do
  if !session[:player].nil?
    session[:input] = params["input"]
    session[:turn] = (session[:turn] == 'X') ? 'O' : 'X'
  else
    if params["input"] == 'X' || params["input"] == 'O'
      session[:player] = params["input"]
    else
      session[:player] = 'X'
    end
    session[:turn] = 'X'
  end

  session[:status] = "#{session[:turn]} Turn"

  puts "Input=#{session[:input]}"
  puts "Player=#{session[:player]}"
  puts "Status=#{session[:status]}"
  # Initiate a GET request to display the updated state.
  redirect "/"
end
