require 'rubygems'
require 'sinatra'
require 'pry'

use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :secret => 'hakuna matata' 

helpers do
  def calculate_total(cards)
    hand = cards.map {|value| value[1]}

    total = 0
    hand.each do |card|
      if card == "Ace"
        total += 11
      else
        total += card.to_i == 0 ? 10 : card.to_i
      end
    end

    #Change value of Aces
    hand.select {|value| value == "Ace"}.count.times do
      break if total <= 21
      total -= 10
    end

    total
  end

  def card_image(card)
    suit = case card[0]
      when "H" then "hearts"
      when "D" then "diamonds"
      when "C" then "clubs"
      when "S" then "spades"
    end

    value = card[1]
    if ["J", "Q", "K", "A"].include?(value)
      value = case card[1]
        when "J" then "jack"
        when "Q" then "queen"
        when "K" then "king"
        when "A" then "ace"
      end
    end
    
    "<img src='/images/cards/#{suit}_#{value}.jpg' class='card_image'>"
  end
end

before do
  @show_hit_or_stay_buttons = true
end

get '/' do
  if session[:player_name]
    redirect '/game'
  else
    redirect '/new_player'
  end
end

get '/new_player' do
  erb :new_player
end

post '/new_player' do
  if params[:player_name].empty?
    @error = "Name is required."
    halt erb(:new_player)
  end
  
  session[:player_name] = params[:player_name]
  redirect '/game'
end

get '/game' do
  SUITS = ["H", "D", "C", "S"]
  VALUES = [2,3,4,5,6,7,8,9,10,"J","Q","K","A"]
  session[:deck] = SUITS.product(VALUES).shuffle!

  session[:dealer_cards] = []
  session[:player_cards] = []
  session[:dealer_cards] << session[:deck].pop
  session[:player_cards] << session[:deck].pop
  session[:dealer_cards] << session[:deck].pop
  session[:player_cards] << session[:deck].pop

  erb :game
end

post '/game/player/hit' do
  session[:player_cards] << session[:deck].pop
  player_total = calculate_total(session[:player_cards])
  if player_total == 21
    @success = "Alright! #{session[:player_name]} has blackjack!"
    @show_hit_or_stay_buttons = false
  elsif calculate_total(session[:player_cards]) > 21
    @error = "#{session[:player_name]} went over 21. Busted with #{calculate_total(session[:player_cards])}."
    @show_hit_or_stay_buttons = false
  end
  erb :game
end

post '/game/player/stay' do
  @success = "#{session[:player_name]} stayed with #{calculate_total(session[:player_cards])}."
  @show_hit_or_stay_buttons = false
  erb :game
end


