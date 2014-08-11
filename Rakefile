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
