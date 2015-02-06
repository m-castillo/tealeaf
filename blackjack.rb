system "clear"

puts "Welcome to BlackJack."
puts
puts "What's your name?"
name = gets.chomp
puts

begin

  VALUES = [2,3,4,5,6,7,8,9,"Kings", "Queens", "Jacks", "Ace"]
  SUITS = ["of Hearts", "of Spades", "of Clubs", "of Diamonds"]
   
  system "clear"

  first_card = VALUES.product(SUITS).sample
  second_card = VALUES.product(SUITS).sample

  check_first_player_card = first_card[0].to_i
  check_second_player_card  = second_card[0].to_i

  first_player_card = check_first_player_card + 10
  second_player_card = check_second_player_card + 10

  if first_card[0] == "Ace"  
    check_first_player_card = first_card[0].to_i
    first_player_card = check_first_player_card + 11
  elsif second_card[0] == "Ace"
    check_second_player_card = second_card[0].to_i 
    second_player_card = check_second_player_card + 11
  end

  if check_first_player_card == 0 and check_second_player_card == 0
    total = first_player_card + second_player_card
        
  elsif check_first_player_card != 0 and check_second_player_card == 0
    total = check_first_player_card + second_player_card
        
  elsif check_first_player_card == 0 and check_second_player_card != 0
    total = first_player_card + check_second_player_card
        
  elsif check_first_player_card != 0 and check_second_player_card != 0
    total = check_first_player_card + check_second_player_card
  end
 
  if total == 21
    puts "#{name} has BlackJack!"
  else

    print "You got #{first_card.join(" ")} and #{second_card.join(" ")}. Your total so far is #{total}."
    puts
 
    begin
      puts
      puts "Do you want another card? Yes (y) or No (n):"
      decision = gets.chomp
      extra_card = VALUES.product(SUITS).sample
      check_extra_card = extra_card[0].to_i
      if decision == "y"
        if extra_card[0] == "Ace"
          check_extra_card = extra_card[0].to_i
          new_extra_card = check_extra_card + 11
          new_total = total + new_extra_card
          if new_total > 21
            temp_total = new_total - 10
            new_total = temp_total
          end
          puts
          puts "Your new card is #{extra_card.join(" ")}. Your new total is #{new_total}." 
          total = new_total
        elsif check_extra_card == 0
          new_check_extra_card = check_extra_card + 10
          new_total = total + new_check_extra_card
          puts
          puts "Your new card is #{extra_card.join(" ")}. Your new total is #{new_total}."
          total = new_total
        elsif check_extra_card != 0
          new_total = total + check_extra_card
          puts
          puts "Your new card is #{extra_card.join(" ")}. Your new total is #{new_total}." 
          total = new_total
        end 
      end
      if total > 21
        puts "Busted!"
          break
      elsif total == 21
        puts "21! Awesome!"
          break 
      end

    end until decision == "n" or total == 21 or total > 21
  end  

    
  first_pc_card = VALUES.product(SUITS).sample
  second_pc_card = VALUES.product(SUITS).sample

  check_first_pc_card = first_pc_card[0].to_i
  check_second_pc_card  = second_pc_card[0].to_i

  first_computer_card = check_first_pc_card + 10
  second_computer_card = check_second_pc_card + 10

  if first_pc_card[0] == "Ace"  
    check_first_pc_player_card = first_pc_card[0].to_i
    first_computer_card = check_first_pc_card + 11
  elsif second_card[0] == "Ace"
    check_second_pc_card = second_pc_card[0].to_i 
    second_computer_card = check_second_pc_card + 11
  end

  if check_first_pc_card == 0 and check_second_pc_card == 0
    total_computer = first_computer_card + second_computer_card 

  elsif check_first_pc_card != 0 and check_second_pc_card == 0
    total_computer = check_first_pc_card + second_computer_card
        
  elsif check_first_pc_card == 0 and check_second_pc_card != 0
    total_computer = first_computer_card + check_second_pc_card
        
  elsif check_first_pc_card != 0 and check_second_pc_card != 0
    total_computer = check_first_pc_card + check_second_pc_card
  end

  puts
  puts "Computer has #{first_pc_card.join(" ")} and #{second_pc_card.join(" ")}. Total is #{total_computer}."

  if total_computer < 17 && total <= 21  #Need one when player goes above 21... computer only needs to stay
    begin
      sleep(0.5)
      extra_pc_card = VALUES.product(SUITS).sample

      check_computer_extra_card = extra_pc_card[0].to_i
      computer_extra_card = check_computer_extra_card + 10
      
      if extra_pc_card[0] == "Ace"
        check_extra_computer_card = extra_pc_card[0].to_i
        new_extra_pc_card = check_extra_computer_card + 11
        new_computer_total = total_computer + new_extra_pc_card
          
        if new_computer_total > 21
            temp_pc_total = new_computer_total - 10
            new_computer_total = temp_pc_total
        end

      elsif check_computer_extra_card == 0
        new_computer_total = total_computer + computer_extra_card

      elsif check_computer_extra_card != 0
        new_computer_total = total_computer + check_computer_extra_card
      end

      total_computer = new_computer_total
      sleep(0.5)
      puts
      puts "Computer has drawn #{extra_pc_card.join(" ")}. The new computer total is #{total_computer}."  
      sleep(0.5)
    end until total_computer > 21 or total_computer == 21 or (total_computer <= 21 && total_computer >= 17)        
  end
  if total <= 21 && total_computer > 21
    puts
    puts "#{name} has #{total} and Computer has #{total_computer}. #{name} has won!"
  elsif total > total_computer && total_computer <=21 && total <= 21
    puts
    puts "#{name} has #{total} and Computer has #{total_computer}. #{name} has won!"
  elsif total_computer > total && total <=21 
    puts
    puts "#{name} has #{total} and Computer has #{total_computer}. Computer has won!"
  elsif total_computer > 21 && total <= 21
    puts
    puts "#{name} has won!"
  elsif total == total_computer
    puts
    puts "We have a tie!"
  elsif total > 21 && total_computer <= 21
    puts
    puts "Computer has won!"
  end
  puts
  puts "Do you want to keep playing? Yes (y) or No (n):"
  keep_playing = gets.chomp
end until keep_playing == "n"

if keep_playing == "n"
  puts
  puts
  puts "*** Thanks for playing BlackJack! ***"
end

