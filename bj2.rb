system "clear"

puts "Welcome to BlackJack!"
puts
puts "What's your name?"
name = gets.chomp.capitalize

VALUES = ["Ace",2,3,4,5,6,7,8,9,10,"Jacks","Queens","Kings"]
SUITS = ["of Hearts", "of Diamonds", "of Clubs", "of Spades"]

begin
  system "clear"
  card_1 = VALUES.product(SUITS).sample #Gets player's first card.
  card_2 = VALUES.product(SUITS).sample #Gets player's second card.
  
  ai_card_1 = VALUES.product(SUITS).sample #Gets computer's first card.
  ai_card_2 = VALUES.product(SUITS).sample #Gets computer's second card.
  
  def first_draw_message(card_one, card_two) # When player gets first two cards.
    puts "Got #{card_one.join(" ")} and #{card_two.join(" ")}. Total is #{temp_total(card_one, card_two)}."
  end
  
  def ai_first_draw_message(card_one, card_two) # When computer gets first two cards.
    puts "Got #{card_one.join(" ")} and #{card_two.join(" ")}. Total is #{ai_temp_total(card_one, card_two)}."
  end
  
  def check_card(card) # Check cards for the values of K, Q, J, A
    temp_card = card[0].to_i
    if card[0] == "Ace" and temp_card == 0 
      new_card = temp_card + 11 # If Ace, add 11
    elsif card[0] != "Ace" and temp_card == 0
      new_card = temp_card + 10 # If K, Q, J, add 10
    else
      card[0].to_i # The value of the other cards (they are Integers).
    end
  end
  
  def temp_total(card_one, card_two) #The first two cards (by player) added.
    if check_card(card_one) == 11 and check_card(card_two) == 11 # Checks if two Aces drawn.
      check_card(card_one) + check_card(card_two) == 12
    else
      check_card(card_one) + check_card(card_two)
    end
  end
  
  def ai_temp_total(card_one, card_two) #The first two cards (by computer) added.
    if check_card(card_one) == 11 and check_card(card_two) == 11 # Checks if two Aces drawn.
      check_card(card_one) + check_card(card_two) == 12
    else
      check_card(card_one) + check_card(card_two)
    end
  end
  
  def extra_card #When player or computer requests extra card.
    card = VALUES.product(SUITS).sample
  end
 # ------------------------- PLAYER TURN -------------------------------
  puts "Alright, #{name}. Here we go..."
  puts
  first_draw_message(card_1, card_2)
  new_total = temp_total(card_1, card_2)
  puts

  
  begin
    if temp_total(card_1, card_2) == 21
      puts "*---- BlackJack! Congratulations! ----*"
      break
    else
      puts
      puts "#{name} now got #{new_total}."
      puts
      puts "Do you want to Hit (h) or Stay (s)?"
      decision = gets.chomp

      if decision == "h"
        temp_extra = extra_card
        extra = temp_extra.join(" ")
        extra_number = check_card(temp_extra)
        if extra_number == 11 and new_total >= 11 # If Ace is drawn, only add one to the overall total (new_total)
         total = new_total + 1
         new_total = total
         puts
         puts "Your last card was #{extra}."
        else
         total = extra_number + new_total
         new_total = total
         puts
         puts "Your last card was #{extra}."
        end

        if new_total > 21 and extra_card == 11
          total = new_total - 10
          new_total = total
        end
       
      elsif decision == "s" and new_total < 21
        puts "Wise decision."
        puts
        puts "Alright. * Computer turn *"
        puts
      end
      
      if new_total > 21
        puts
        puts "==> #{name} got busted with #{new_total}!"
        puts
        break
      end 
    end  
  end until decision != "h" or new_total == 21
  
  puts
  puts "*---- Now you have #{new_total}. ----*"
  puts
  puts
  puts "Now it's Computer's turn."
  puts
  #---------------------- COMPUTER TURN --------------------------------------
  ai_first_draw_message(ai_card_1, ai_card_2)
  ai_new_total = ai_temp_total(ai_card_1, ai_card_2)

  if ai_temp_total(ai_card_1, ai_card_2) == 21
    puts "*---- Computer got BlackJack! ----*"
    break
  elsif new_total <= 21 and ai_new_total < 21
    begin
      temp_extra = extra_card
      extra = temp_extra.join(" ")
      extra_number = check_card(temp_extra)

      if ai_new_total < 21 and ai_new_total < 17
        if extra_number == 11 and new_total >= 11
          puts
          sleep(1)
          ai_total = ai_new_total + 1
          ai_new_total = ai_total
          puts "Computer's last card was #{extra}."
          puts
          puts "*---- Computer now has #{ai_new_total}. ----*"
        else
          sleep(1.5)
          puts
          ai_total = extra_number + ai_new_total
          ai_new_total = ai_total
          puts
          puts "Computer's last card was #{extra}."
          puts
          sleep(1.5)
          puts "*---- Computer now has #{ai_new_total}. ----*"
        end

        if ai_new_total > 21 and extra_number == 11
          ai_total = ai_new_total - 10
          ai_new_total = ai_total
        end
      end

      if ai_new_total > 21
        break
      end
    end until ai_new_total <= 21 and ai_new_total >= 17

  elsif new_total > 21
    sleep(1)
    puts
    puts "*---- Computer feels fine with #{ai_new_total}. ----*"
  end
 # ------------------------ COMPARING RESULTS ---------------------------
  sleep (1)    
  if (new_total > ai_new_total) and (new_total <= 21) 
    puts
    puts "*---- #{name} has won. ----*"
  elsif (new_total < ai_new_total) and (ai_new_total <= 21)
    puts
    puts "*---- Computer has won. ----*"
  elsif (new_total == ai_new_total) and (new_total < 21 and ai_new_total < 21)
    puts
    puts "*---- It's a tie. ----*"
  elsif (new_total <= 21) and (ai_new_total > 21)
    puts
    puts "*---- #{name} has won. ----*"
  end
    
  puts
  puts "==> Would you like to keep playing?"
  keep_playing = gets.chomp

end until keep_playing == "n"

puts "Thank you for playing BlackJack!"
puts
