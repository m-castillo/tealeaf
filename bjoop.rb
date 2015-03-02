class Deck 
SUITS = ["Hearts", "Diamonds", "Spades", "Clubs"]
VALUES = [2,3,4,5,6,7,8,9,10,"Jacks","Queen","King","Ace"]

  def cards
    VALUES.product(SUITS).shuffle!
  end
end

module Hand
  def take_card
    Deck.new.cards.pop
  end

  def add_card
    @cards << take_card
  end

  def player_deck
    @cards
  end

  def player_deck_display
    puts "<-- #{@name} now has: #{player_deck} -->"
    puts
    puts "#{@name}'s total is #{total_cards}"
    puts
    puts
  end

  def total_cards
    total = 0
    @cards.each do |value|
      if value[0] == "Ace"
        total += 11
      elsif value[0].to_i == 0
        total += 10
      else
        total += value[0]
      end   
    end

    @cards.select{|card| card[0] == "Ace"}.count.times do
      break if total <= 21
      total -= 10
    end

    total
  end
end

class Human
  include Hand

  attr_reader :name
  attr_accessor :cards

  def initialize
    @name
    @cards = []
  end

  def game_hand
    first_two_cards
    another_card
  end

  def greet
    system "clear"
    puts
    puts "*--- Welcome to BlackJack ---*"
    puts
    puts "Dear human, what's your name?"
    @name = gets.chomp.capitalize
    puts
  end

  def first_two_cards
    take_card
    add_card
    take_card
    add_card
    take_card
    puts "Here are your first two cards: --- #{player_deck} ---"
    sleep(1)
    puts
    puts "You have #{total_cards}."
    puts
  end

  def another_card
    begin
      puts "Do you want to Hit (h) or Stay (s)?"
      decision = gets.chomp
      if decision == "h"
        take_card
        add_card
        player_deck_display
      else
        puts "Thanks! Your hand ends up with #{total_cards}."
        puts
        puts " *** ------------------------ ***"
      end
    end while decision == "h" && total_cards < 21
  end
end

class Computer
  include Hand

  attr_accessor :cards
  attr_reader :name, :human

  def initialize
    @name = "Dealer-#{rand(1..500)}"
    @cards = []
    @human = Human.new
  end

  def dealer_game
    @cards
    take_card
    add_card
    player_deck_display
    sleep(1)
    take_card
    add_card
    sleep(1)
    player_deck_display
    if @human.total_cards > 21
      puts "#{@name} stays at #{@total_cards}."
    else 
      another_card
    end
  end

  def another_card
    begin
      if total_cards == 21
        puts "#{@name} has 21."
      elsif total_cards < 17
        sleep(1)
        take_card
        add_card
        player_deck_display
        puts "#{@name} now has #{total_cards}."
        puts
        sleep(1)
      elsif total_cards > 21
        puts "#{@name} is busted."
        puts
        break
      end
    end until total_cards == 21 || (total_cards >= 17 && total_cards <=21)
  end
end

class Game
  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def win
    sleep(1.5)
    puts
    puts "#{@human.name} got #{@human.total_cards} and #{@computer.name} got #{@computer.total_cards}."
    puts
    if (@human.total_cards > @computer.total_cards) && ((@human.total_cards <= 21) && (@computer.total_cards <= 21))
      puts "=> #{@human.name} has won!"
      puts
    elsif (@human.total_cards < @computer.total_cards) && ((@human.total_cards <= 21) && (@computer.total_cards <= 21))
      puts "=> #{@computer.name} has won!"
      puts
    elsif (@human.total_cards == @computer.total_cards) && ((@human.total_cards <= 21) && (@computer.total_cards <= 21))
      puts "=> #{@human.name} and #{@computer.name} are even."
      puts
    elsif (@human.total_cards > 21) && (@computer.total_cards <= 21)
      puts "=> #{@computer.name} has won! #{@human.name} went over 21."
      puts
    elsif (@human.total_cards <= 21) && (@computer.total_cards > 21)
      puts "=> #{@human.name} has won. #{@computer.name} went over 21."
      puts
    elsif (@human.total_cards > 21) && (@computer.total_cards > 21)
      puts "=> Both players have lost. #{@human.name} and #{@computer.name} went over 21."
      puts
    end
  end

  def play_again?
    begin
      puts "Do you want to play again? Please hit 'y' for Yes and 'n' for No."
      decision = gets.chomp
      if decision == "y"
        puts "Alright. Let's keep playing."
        @human.cards.clear
        @computer.cards.clear
        game_logic
        sleep(2)
      elsif decision == "n"
        puts "*** Thank you for playing BlackJack ***"
        break
      end
    end until decision == "y"
  end

  def intro
    @human.greet
  end

  def game_logic
    @human.game_hand
    sleep(1)
    @computer.dealer_game
    win
    sleep(2)
    play_again?
  end
end

game = Game.new
game.intro
game.game_logic
