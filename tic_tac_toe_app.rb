require 'sinatra'
require 'sinatra/reloader' if development?
require_relative 'board.rb'
require_relative 'ai.rb'

enable :sessions

get '/' do
  erb :index
end

post '/' do
  if params["input"] == "restart"
    session[:board] = Board.new
    session[:turn] = 'X'
    session[:game_over] = true
  elsif session[:game_over].nil? || session[:game_over] == true
    session[:board] = Board.new
    session[:turn] = 'X'
    session[:game_over] = false

    if params["input"] == 'X' || params["input"] == 'O'
      session[:player] = params["input"]
    else
      session[:player] = 'X'
      session[:input] = params["input"].to_i
      session[:board].mark(session[:input], session[:turn])
      session[:turn] = 'O'
    end

    session[:machine] = AI_Player.new(session[:player] == 'X' ? 'O' : 'X')
  else
    session[:input] = params["input"].to_i

    if session[:turn] == session[:player]
      if session[:board].mark(session[:input], session[:turn])
        session[:turn] = (session[:turn] == 'X') ? 'O' : 'X'
      end
    else
      session[:board].mark(session[:machine].get_next_move(session[:board]), session[:turn])
      session[:turn] = (session[:turn] == 'X') ? 'O' : 'X'
    end
  end

  winner = session[:board].check_winner
  if !winner.nil?
    session[:status] = "<span id='bold'>#{winner} wins!</span>"
    session[:game_over] = true
  elsif !session[:board].moves_left?
    session[:status] = "<span id='bold'>It's a draw!</span>"
    session[:game_over] = true
  else
    session[:status] = "It's #{session[:turn]}'s turn."
  end

  # Initiate a GET request to display the updated state.
  redirect "/"
end

def get(position)
    session[:board].nil? ? nil : session[:board].get(position)
end
