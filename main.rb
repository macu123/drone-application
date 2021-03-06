require_relative 'drone'

puts 'Initialize a new Drone'
drone = Drone.new
drone.print_all_stats

puts 'Drone is trying to take off before engines turned on'
drone.take_off
drone.print_all_stats

puts 'Drone is trying to stabilize before taking off'
drone.stabilize
drone.print_all_stats

Drone::MOVEMENT_ENGINE_MAPPING.each_key do |movement|
  next if movement == :up

  puts "Drone is trying to move #{movement} before taking off"
  move_method = "move_#{movement}"
  drone.send(move_method)
  drone.print_all_stats
end

puts 'Drone is trying to take off after engines turned on'
drone.turn_on_engines
drone.take_off

Drone::MOVEMENT_ENGINE_MAPPING.each_key do |movement|
  puts "Drone is trying to move #{movement} while in the air"
  move_method = "move_#{movement}"
  drone.send(move_method)

  puts "Drone is trying to move #{movement} with custom value while in the air"
  drone.send(move_method, { high_power: 90, low_power: 35 })
end

puts 'Drone is trying to move forward with invalid data while in the air'
drone.move_forward(high_power: 10, low_power: 90)
drone.print_all_stats

puts 'Tap the drone'
drone.tap

puts 'One of engines start to break'
engines = drone.instance_variable_get(:@engines)
engines.first.turn_off
drone.print_engines_status

puts 'Drone is trying to move forward when one engine breaks'
drone.move_forward

puts 'Drone is trying to take off again after engines turned on'
drone.turn_on_engines
drone.take_off

puts 'One of engines start to break after taking off'
engines = drone.instance_variable_get(:@engines)
engines.first.turn_off
drone.print_engines_status

puts 'Drone is trying to stabilize in the air when one engine breaks'
drone.stabilize
