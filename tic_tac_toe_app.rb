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
    session[:first_turn] = true

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
      # Player's turn
      if session[:board].mark(session[:input], session[:turn])
        session[:turn] = (session[:turn] == 'X') ? 'O' : 'X'
      end
    else
      # Machine's turn - make it possible to sometimes beat it.
      if session[:first_turn] && [true, true, false].sample
        # Make a "bad" first move.
        positions = [2,4,6,8]
        position = positions.sample
        if !session[:board].get(position).nil?
          # If that position is already taken, try again.
          positions.delete(position)
          position = positions.sample
        end
        session[:board].mark(position, session[:turn])
      else
        session[:board].mark(session[:machine].get_next_move(session[:board]), session[:turn])
      end

      session[:turn] = (session[:turn] == 'X') ? 'O' : 'X'
      session[:first_turn] = false
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
