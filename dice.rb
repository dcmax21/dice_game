require 'ruby2d'

set fullscreen: true
def resolve_dice_value(frame)
  frame_to_value = {
    5 => 6,
    4 => 5,
    3 => 4,
    2 => 3,
    1 => 2,
    6 => 1
   
  }
  frame_to_value[frame]
end

def result_text(text)
   t = Text.new(
    text,
    x: 250, y: 180,
    size: 50,
    color: 'white',
    z: 10
    
    )  
  t.x = (320 - (t.width / 2))
  t 
end

def set_player_score(dice_value, player)
  t = Text.new(
    "Player #{player}: #{dice_value}" ,
    y: 10,
    size: 30,
    color: 'white',
    z: 10
  )
    
  if player == 1 
    t.x = ((320 - 160) -(t.width / 2))
  else 
    t.x = ((320 + 160) - (t.width / 2))
  end
  t
end

def play_again_button
  rectangle_obj = Rectangle.new(
    x: 125, y: 250,
    width: 200, height: 50,
    color: 'red',
    z: 20
  )
  rectangle_obj.x = (320 - (rectangle_obj.width / 2))
  t = Text.new(
    'play again',
    x: 150, y: 250,
    size: 30,
    color: 'white',
    z: 25
  )
  t.x = (320 - (rectangle_obj.width / 2) + ((rectangle_obj.width - t.width) / 2) )
  rectangle_obj.x = (320 - (rectangle_obj.width / 2))
end

def exit_text
  y = Text.new(
    'press e to exit',
    x: 450, y: 300,
    size: 30,
    color: 'white',
    z: 25
  ) 
 center_of_window = 640 / 2
 center_of_text =  y.width / 2
 y.x = center_of_window - center_of_text
end


rectangle_obj = nil
dice_roll = 0
dice_roll_value = []
coin = Sprite.new(
  "#{File.basename(Dir.getwd)}/red_dice.png",
  clip_width: 128,
  time: 50,
  loop: true,
  x: 256,
  y: 150,
  
  animations: {
    roll: 1..6,
    result: rand(6)
  }
)

on :mouse_down do |event|
  unless dice_roll >= 2
    coin.play animation: :roll, loop: true 
  end 

  if dice_roll == 2
    if (event.x.between?(220,420) && event.y.between?(250,300))
      rectangle_obj = nil
      dice_roll = -1
      dice_roll_value = []
      clear 

      coin.add
    end
  end
end

on :key_held do |event|
  if event.key == 'e'
    return
  end
end

on :mouse_up do |event|
  if dice_roll >= 0 && dice_roll < 2
    dice_roll += 1
    coin.play animation: :result, loop: false
    # Resolve current frame and dice value
    current_frame = coin.instance_variable_get(:@current_frame)
    dice_value = resolve_dice_value(current_frame)
    # Push dice value to array
    dice_roll_value.push(dice_value)

    set_player_score(dice_value, dice_roll)
    if dice_roll == 2
      coin.remove
      if dice_roll_value[0] > dice_roll_value[1]
        result_text("player 1 wins")
      elsif dice_roll_value[0] < dice_roll_value[1]
        result_text("player 2 wins")
      else
        result_text("Draw")
      end
      # Play Again Logic
      play_again_button()
      # Exit Logic
      exit_text()
    end
  elsif dice_roll == -1
    dice_roll += 1
    puts "reseting"
  end 
end
show



