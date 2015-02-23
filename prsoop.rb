class Game
  MOVES = {"p" => "Paper", "s" => "Scissors", "r" => "Rock"}
# --------------------- PLAYER --------------------------------------
  class Player
    def play
       puts "Choose 'p' for Paper, 'r' for Rock, and 's' for Scissors:"
       @hand = gets.chomp
       unless MOVES.keys.include?(@hand)
        puts "Please enter 'p', 'r', or 's'."
        play
      end
    end

    def player_choice
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
  class GamePlay
    attr_reader :player, :computer, :name

    def initialize
      @player = Player.new
      @computer = Computer.new
    end

    def introduction_to_game
      @player.play
      @player_pick = @player.player_choice
      @computer_pick = @computer.computer_choice
    end
    
    def compare_hands
      puts "Player chose #{@player_pick} and Computer got #{@computer_pick}."
      if (@player_pick ==  "Paper" && @computer_pick == "Rock") || 
         (@player_pick == "Scissors" && @computer_pick == "Paper") ||
         (@player_pick == "Rock" && @computer_pick == "Scissors")
        puts
        puts "=> Player has won!"
      elsif @computer_pick == @player_pick
        puts
        puts "=> Tie!"
      else
        puts
        puts "=> Computer has won!"
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
        puts
        puts "Thank you for playing!"
        break
      end
    end until decision == "y" || decision == "n"
  end

  def greet
      puts "What's your name?"
      name = gets.chomp.capitalize
      puts
      puts "Well, hello #{name}! Welcome to Paper/Rock/Scissors."
      puts
  end

  def start
    game_play = GamePlay.new
    game_play.introduction_to_game
    game_play.compare_hands
    another_round
  end
end

game = Game.new
game.greet
game.start
