# db/seeds.rb
puts "--- Starting Master Seed Process ---"

Dir[Rails.root.join('db/seeds/*.rb')].sort.each do |seed|
  puts "Seeding: #{File.basename(seed)}"
  load seed
end

puts "--- All Seeds Completed Successfully ---"
