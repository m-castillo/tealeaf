require 'rubygems'
require 'sinatra'
require 'pry'

use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :secret => 'hakuna matata' 

get '/' do
  if session[:player_name]
    session[:total_money] = 200
    redirect '/main'
  else
    redirect '/new_player'
  end
end

get '/main' do
  if session[:player_name]
    session[:total_money] = 200
    @bet_box = true
    @main = "Your amount is $#{session[:total_money]}. How much do you want to bet?"
  else
    redirect '/new_player'
  end
  erb :main
end

post '/player_bet' do
  session[:player_bet] = params[:player_bet].to_i
  if session[:player_bet] > session[:total_money]
    @error = "Please, enter an amount you can afford."
    @bet_box = true
    halt (erb :main)
  else
    @bet_box = false
    @success = "Great. You have bet $#{session[:player_bet]}. Please select one of the games below."
  end
  erb :main
end


# --------------- BLACKJACK ---------------
# -------- For Pick-5 go to Line 260 ------

BLACKJACK = 21
DEALER_MIN_HIT = 17

helpers do
  def calculate_total(cards)
    hand = cards.map {|value| value[1]}

    total = 0
    hand.each do |card|
      if card == "A"
        total += 11
      else
        total += card.to_i == 0 ? 10 : card.to_i
      end
    end

    #Change value of Aces
    hand.select {|value| value == "A"}.count.times do
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

  def play_again
    @play_again = true
  end

  def win_blackjack
    session[:total_money] += session[:player_bet]  
  end

  def lose
    session[:total_money] -= session[:player_bet]
  end

  def pick_win_5_numbers
    session[:total_money] += (session[:player_bet] * 10)
  end

  def pick_win_4_numbers
    session[:total_money] += (session[:player_bet] * 7)
  end

  def pick_win_3_numbers
    session[:total_money] += (session[:player_bet] * 4)
  end

  def pick_win_2_numbers
    session[:total_money] += (session[:player_bet] * 2)
  end

  def pick_win_1_numbers
    session[:total_money] += (session[:player_bet] * 1)
  end
end

before do
  @show_hit_or_stay_buttons = true
end

get '/new_player' do
  erb :new_player
end

post '/new_player' do
  if params[:player_name].empty?
    @error = "Name is required."
    halt erb(:new_player)
  end
  
  session[:player_name] = params[:player_name].capitalize
  redirect '/main'
end

get '/game' do
  if session[:player_name]
    session[:turn] = session[:player_name]

    SUITS = ["H", "D", "C", "S"]
    VALUES = [2,3,4,5,6,7,8,9,10,"J","Q","K","A"]
    session[:deck] = SUITS.product(VALUES).shuffle!

    session[:dealer_cards] = []
    session[:player_cards] = []
    session[:dealer_cards] << session[:deck].pop
    session[:player_cards] << session[:deck].pop
    session[:dealer_cards] << session[:deck].pop
    session[:player_cards] << session[:deck].pop
  else
    redirect '/new_player'
  end

  erb :game
end

post '/game/player/hit' do
  session[:player_cards] << session[:deck].pop
  player_total = calculate_total(session[:player_cards])
  if player_total == BLACKJACK
    @success = "Alright! #{session[:player_name]} has 21! You now have #{win_blackjack}."
    @show_hit_or_stay_buttons = false
    play_again
  elsif player_total > BLACKJACK
    @error = "#{session[:player_name]} went over 21. Busted with #{calculate_total(session[:player_cards])}. You now have #{lose}."
    @show_hit_or_stay_buttons = false
    play_again
  end
  erb :game, layout: false
end

post '/game/player/stay' do
  @success = "#{session[:player_name]} stayed with #{calculate_total(session[:player_cards])}."
  @show_hit_or_stay_buttons = false
  redirect '/game/dealer'
end

get '/game/dealer' do
  session[:turn] = "dealer"

  @show_hit_or_stay_buttons = false

  dealer_total = calculate_total(session[:dealer_cards])

  if dealer_total == BLACKJACK
    @error = "Dealer got 21. Your bet was #{session[:player_bet]}. You now have #{lose}."
    play_again
  elsif dealer_total >= DEALER_MIN_HIT && dealer_total < BLACKJACK
    redirect '/game/compare'
  elsif dealer_total > BLACKJACK
    @success = "Dealer busted with #{calculate_total(session[:dealer_cards])}. Your bet was #{session[:player_bet]}. You now have #{win_blackjack}."
    play_again
  else
    @show_dealer_hit_button = true
  end

  erb :game, layout: false 
end

post '/game/dealer/hit' do
  session[:dealer_cards] << session[:deck].pop
  redirect '/game/dealer'
end

get '/game/compare' do
  @show_hit_or_stay_buttons = false

  player_total = calculate_total(session[:player_cards])
  dealer_total = calculate_total(session[:dealer_cards])

  if player_total < dealer_total
    @error = "#{session[:player_name]} has #{calculate_total(session[:player_cards])}. Dealer got #{calculate_total(session[:dealer_cards])}. Dealer has won. Your bet was #{session[:player_bet]}. You now have $#{lose}."
    play_again
  elsif player_total > dealer_total
    @success = "#{session[:player_name]} has #{calculate_total(session[:player_cards])}. Dealer got #{calculate_total(session[:dealer_cards])}. #{session[:player_name]} has won! Your bet was #{session[:player_bet]}. You now have $#{win_blackjack}."
    play_again
  else
    @success = "#{session[:player_name]} and Dealer tie."
    play_again
  end

  erb :game, layout: false
end

get '/another_bet' do
  @play_again = false
  @show_hit_or_stay_buttons = false
  @bet_again = true
  if session[:total_money] <= 10
    redirect 'http://thegamblinghelpline.com'
  end

  erb :game, layout: false
end

post '/player_bet_bj' do
  session[:player_bet] = params[:player_bet_bj].to_i

  if session[:player_bet] > session[:total_money]
    @error = "Please, enter an amount you can afford."
    @bet_again = true
    halt (erb :main)
  else
    @bet_again = false
    redirect '/game'
  end
  erb :game
end

# -------------------- PICK 5 GAME ----------------------------
# --------------For Blackjack go to Line 38 -------------------


get '/pick_five' do
  if session[:player_name]
    @current_bet = true
    @show_number_input = true
    session[:number_bank] = []
    session[:computer_number_bank] = []
    session[:player_number_bank] = []
    (1..50).each {|value| session[:number_bank] << value }
    erb :pick_five, layout: false
  else
    redirect '/new_player'
  end
  erb :pick_five
end

post '/player_choice' do
  @show_number_input = true
  @current_bet = true
  if params[:player_number].to_i > 50
    @error = "Please, one of the numbers below. Below 50!"
    halt (erb :pick_five)
  elsif params[:player_number].to_i < 1
    @error = "Please, one of the numbers below. Meaning 1 or above. "
    halt (erb :pick_five)
  end

  session[:player_number] = params[:player_number].to_i
  redirect '/player_game'
end

get '/player_game' do
  @show_number_input = true
  @current_bet = true
  if (session[:player_number_bank].include? session[:player_number])
    @error = "Please enter one of the numbers below."
    session[:player_number_bank].delete(session[:player_number])
  end
  
  session[:player_number_bank] << session[:player_number]
  session[:number_bank].delete(session[:player_number])

  while session[:player_number_bank].length == 5
    redirect '/pick_computer'
  end

  erb :pick_five
end

get '/pick_computer' do
  @current_bet = true
  @show_number_input = false
  @computer = "Computer Picks:"
  session[:ai_number_bank] = []
  session[:computer_number_bank] = []
  (1..50).each { |value| session[:ai_number_bank] << value }
  begin
    session[:computer_number_bank] << session[:ai_number_bank].sample
    session[:ai_number_bank].delete(session[:ai_number_bank].sample)
  end until session[:computer_number_bank].length == 5

  erb :pick_five
  redirect '/compare_numbers'
end

get '/compare_numbers' do
  @current_bet = true
  @show_number_input = false
  @computer = "Computer Picks:"
  winning_draw = session[:player_number_bank] & session[:computer_number_bank]
  draw = winning_draw.length

  win = winning_draw.sort.join(", ")

  if draw == 5
    @success = "You better get to your closest 7/11 and play these numbers! You won $#{session[:player_bet] * 10}. Your amount is now $#{pick_win_5_numbers}."
  elsif draw == 4
    @success = "4 out of 5? Dang! I'd consider playing them for real. You won $#{session[:player_bet] * 7}. Your amount is now $#{pick_win_4_numbers}."
  elsif draw == 3
    @success = "Hey... 3 out of 5 is not that bad... but not that good, either. You won $#{session[:player_bet] * 4}. Your amount is now $#{pick_win_3_numbers}."
  elsif draw == 2
    @success = "Hey. Better than one, right? You won $#{session[:player_bet] * 2}. Your amount is now $#{pick_win_2_numbers}."
  elsif draw == 1
    @success = "One number. At least you recouped some dough. You won $#{session[:player_bet] * 1}. Your amount is now $#{pick_win_1_numbers}."
  elsif draw == 0 
    @error = "Do yourself a favor: don't ever play lottery. You know have $#{lose}."
  end

  if winning_draw.empty?
    @win_message = "You got ZERO matches."
  else
    @win_message = "Matched numbers: #{win}."
  end

  @match = "#{session[:player_name]} has #{draw} number(s) correct."

  @play_again = true
  erb :pick_five
end

get '/pick_five_bet' do
  @bet_again = true
  @computer = "Computer Picks:"
  if session[:total_money] <= 10
    redirect 'http://thegamblinghelpline.com'
  end

  erb :pick_five
end

post '/player_bet_pick5' do
  session[:player_bet] = params[:player_bet_pick5].to_i
  if session[:player_bet] > session[:total_money]
    @error = "Please, enter an amount you can afford."
    @bet_again = true
    halt (erb :pick_five)
  else
    @bet_again = false
    redirect '/pick_five'
  end
  erb :pick_five
end
