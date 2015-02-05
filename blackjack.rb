system "clear"

puts "Welcome to BlackJack."
puts
puts "What's your name?"
name = gets.chomp
puts

begin
  VALUES = [1,2,3,4,5,6,7,8,9,10]
  SUITS = ["of Hearts", "of Spades", "of Clubs", "of Diamonds"]
    
  first_player_card = VALUES.product(SUITS).sample
  second_player_card = VALUES.product(SUITS).sample
  total = first_player_card[0] + second_player_card[0]
 
  system "clear"
    
  print "You got #{first_player_card.join(" ")} and #{second_player_card.join(" ")}. Your total so far is #{total}."
  puts
  begin
    puts
    puts "Do you want another card? Yes (y) or No (n):"
    decision = gets.chomp
    extra_card = VALUES.product(SUITS).sample
    if decision == "y"
      new_total = total + extra_card[0]
      puts
      puts"Your new card is #{extra_card.join(" ")}. Your new total is #{new_total}."
      total = new_total 
    end
    if total > 21
      puts "Busted!"
        break
    elsif total == 21
      puts "21! Awesome!"
    end
  end until decision == "n" or total == 21 or total > 21
    
  first_computer_card = VALUES.product(SUITS).sample
  second_computer_card = VALUES.product(SUITS).sample
  total_computer = first_computer_card[0] + second_computer_card[0]

  puts
  puts "Computer has #{first_computer_card.join(" ")} and #{second_computer_card.join(" ")}. Total is #{total_computer}."
  if total_computer < 17 && total <= 21  #Need one when player goes above 21... computer only needs to stay
    begin
      sleep(0.5)
      computer_extra_card = VALUES.product(SUITS).sample
      new_computer_total = total_computer + computer_extra_card[0]
      total_computer = new_computer_total
      sleep(0.5)
      puts
      puts "Computer has drawn #{computer_extra_card.join(" ")}. The new computer total is #{total_computer}."  
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

