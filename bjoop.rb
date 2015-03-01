class Deck 
SUITS = ["of Hearts", "of Diamonds", "of Spades", "of Clubs"]
VALUES = [2,3,4,5,6,7,8,9,10,"Jacks","Queen","King","Ace"]

  def cards
    VALUES.product(SUITS).shuffle!
  end
end

module Hand
  def take_card
    deck = Deck.new
    @another_card = deck.cards.pop
  end

  def add_card
    @cards << @another_card
  end

  def player_deck
    @cards
  end

  def player_deck_display
    puts "<-- #{@name} now has: #{player_deck} -->"
    puts "<-- The total is #{total_cards} -->"
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
    total
  end
end

class Human
  include Hand

  attr_reader :human_name
  attr_accessor :cards

  def initialize
    @human_name
    @cards = []
  end

  def game_hand
    greet
    first_two_cards
    another_card_human?
  end

  def greet
    puts "*--- Welcome to BlackJack ---*"
    puts
    puts "Dear human, what's your name?"
    @human_name = gets.chomp
  end

  def first_two_cards
    take_card
    add_card
    take_card
    add_card
    take_card
    computer = Computer.new
    computer.take_card
    computer.add_card
    puts "Here are your first two cards: --- #{player_deck} ---"
    puts "This is dealer's card: --- #{computer.player_deck}"
    puts "You have #{total_cards}."
  end

  def another_card_human?
    begin
      puts "Another card?"
      decision = gets.chomp
      if decision == "y"
        take_card
        add_card
        player_deck_display
      else
        puts "Thanks! Your hand ends up with #{total_cards}."
      end
    end while decision == "y"
  end
end

class Computer
  include Hand

  attr_accessor :cards
  attr_reader :computer_name

  def initialize
    @computer_name = "Dealer-#{rand(1..500)}"
    @cards = []
  end

  def dealer_game
    @cards
    take_card
    add_card
    another_card_computer?
  end

  def another_card_computer?
    begin
      if total_cards == 21
        puts "#{@computer_name} has 21."
        break
      elsif total_cards < 17
        take_card
        add_card
        player_deck_display
        puts "#{@computer_name} now has #{total_cards}."
        puts
      elsif total_cards > 21
        puts "#{@computer_name} is busted."
        puts
        break
      end
    end until total_cards == 21 || (total_cards >= 17 && total_cards <=21)
  end
end

class Win
  attr_reader :human_name, :computer_name
  # No comparisson yet. Trying to get total values in this class.
   def winning_hand
    human = Human.new
    computer = Computer.new
    puts "#{@human_name} has #{human.total_cards} and #{@computer_name} has #{computer.total_cards}."
  end
end

def game
  human = Human.new
  computer = Computer.new
  win = Win.new
  human.game_hand
  computer.dealer_game
  win.winning_hand
end

game



    


