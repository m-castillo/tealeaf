system "clear"

puts "Welcome to BlackJack!"
puts "What's your name?"
name = gets.chomp.capitalize

VALUES = ["Ace",2,3,4,5,6,7,8,9,10,"Jacks","Queens","Kings"]
SUITS = ["of Hearts", "of Diamonds", "of Clubs", "of Spades"]

begin
  system "clear"
  card_1 = VALUES.product(SUITS).sample
  card_2 = VALUES.product(SUITS).sample
  
  ai_card_1 = VALUES.product(SUITS).sample
  ai_card_2 = VALUES.product(SUITS).sample
  
  def first_draw_message(card_one, card_two)
    puts "Got #{card_one.join(" ")} and #{card_two.join(" ")}. Total is #{temp_total(card_one, card_two)}."
  end
  
  def ai_first_draw_message(card_one, card_two)
    puts "Got #{card_one.join(" ")} and #{card_two.join(" ")}. Total is #{ai_temp_total(card_one, card_two)}."
  end
  
  def check_card(card)
    temp_card = card[0].to_i
     temp_card = card[0].to_i
    if card[0] == "Ace"
      new_card = temp_card + 11
    elsif 
      new_card = temp_card + 10
    end
    if temp_card == 0 
      new_card
    else
      card[0].to_i
    end
  end
  
  def temp_total(card_one, card_two)
    check_card(card_one) + check_card(card_two)
  end
  
  def ai_temp_total(card_one, card_two)
    check_card(card_one) + check_card(card_two)
  end
  
  def extra_card
    card = VALUES.product(SUITS).sample
    puts "Next card is #{card.join(" ")}."
    check_card(card)
  end
 
  puts "Alright, #{name}. Here we go..."
  first_draw_message(card_1, card_2)
  new_total = temp_total(card_1, card_2)
  puts
  
  if new_total == 21
      puts "*---- BlackJack! Congratulations! ----*"
  end
  
  begin
    puts
    puts "*---- #{name} now got #{new_total}. ----*"
    puts
    puts "Do you want to Hit (h) or Stay (s)?"
    decision = gets.chomp

    if decision == "h"
      puts  
       if new_total >= 11 and (extra_card == 11)
         total_ace = extra_card + new_total
         new_total = total_ace - 10
      elsif 
         total = extra_card + new_total
         new_total = total
     end
    elsif decision == "s" and new_total < 21
      puts
      puts "Wise decision."
      puts
      puts "Alright. Computer turn"
      puts
    end
    
    if new_total > 21
      puts "#{name} got busted!"
      puts
      break
    end   
  end until decision != "h" or new_total == 21
  
  puts
  puts "*---- Now you have #{new_total}. ----*"
  puts
  puts "Now it's Computer's turn."
  puts

  ai_first_draw_message(ai_card_1, ai_card_2)
  ai_new_total = ai_temp_total(ai_card_1, ai_card_2)

  if new_total < 21 and ai_new_total < 21
    begin
      if ai_new_total < 21 and ai_new_total < 17
        sleep(1)
        puts
        ai_total = extra_card + ai_new_total
        ai_new_total = ai_total
        puts
        sleep(0.5)
        puts "Computer now has #{ai_new_total}."
        puts
        ai_new_total
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

  sleep (1)    
  if (new_total > ai_new_total) and (new_total <= 21) 
    puts
    puts "*---- #{name} has won. ----*"
  elsif (new_total < ai_new_total) and (ai_new_total <= 21)
    puts "*---- Computer has won. ----*"
  elsif (new_total == ai_new_total) and (new_total < 21 and ai_new_total < 21)
    puts
    puts "*---- It's a tie. ----*"
  elsif (new_total <= 21) and (ai_new_total > 21)
    puts "*---- #{name} has won. ----*"
  end
    
  puts
  puts "==> Would you like to keep playing?"
  keep_playing = gets.chomp

end until keep_playing == "n"


    

