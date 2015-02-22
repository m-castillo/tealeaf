#Game

class Game
  MOVES = {"p" => "Paper", "s" => "Scissors", "r" => "Rock"}
# --------------------- PLAYER --------------------------------------
  class Player
    def greet
      puts "What's your name?"
      @name = gets.chomp
      puts "Alright, #{@name}. Choose 'p' for Paper, 'r' for Rock, and 's' for Scissors:"
      @name
    end

    def play
       @hand = gets.chomp
       unless MOVES.keys.include?(@hand)
        puts "Please enter 'p', 'r', or 's'."
        play
      end
    end

    def select
      MOVES.select {|key, value| key == @hand}.values.join(" ")
    end
  end
# ---------------------COMPUTER ------------------------------------
  class Computer
    def computer_choice
      possible_choices = MOVES.values
      possible_choices[rand(possible_choices.length)]
    end
  end
# ------------------- GAME PLAY -----------------------------------
  class Game_Play
    attr_accessor :player, :computer, :name

    def introduction_to_game
      player = Player.new
      computer = Computer.new
      @name = player.greet
      player.play
      @player = player.select
      @computer = computer.computer_choice
    end
    
    def compare_hands
      puts "#{@name} chose #{@player} and Computer got #{@computer}."
      if (@player ==  "Paper" && @computer == "Rock") || 
         (@player == "Scissors" && @computer == "Paper") ||
         (@player == "Rock" && @computer == "Scissors")
        puts "#{@name} has won!"
      elsif @computer == @player
        puts "Tie!"
      else
        puts "Computer has won!"
      end
    end
  end

  def another_round
    puts "Do you want to play again? Please select 'y' for Yes, and 'n' for No."
    decision = gets.chomp
    begin
      if decision == "y"
        start
      else
        puts "Thank you for playing!"
      end
    end until decision == "y" || decision == "n"
  end

  def start
    gp = Game_Play.new
    gp.introduction_to_game
    gp.compare_hands
    another_round
  end
end

game = Game.new
game.start