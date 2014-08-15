task :console do
  require 'irb'
  require 'irb/completion'
  require_relative 'bin/hanabi'
  ARGV.clear
  IRB.start
end

task :play do
  sh 'ruby bin/hanabi.rb Nick Jeannie Eli Tim Danny'
end

task :stats do
  n = 1
  scores = []
  100.times do
    results = `ruby bin/hanabi.rb Nick Jeannie Eli Tim Danny`
    match = /The team's final score was (\d*)!/.match(results)
    puts "Match #{n} Score: #{match.captures[0]}"
    scores << match.captures[0].to_i
    n += 1
  end
  puts
  puts "AVERAGE SCORE: #{scores.reduce(:+) / scores.length}"
end
