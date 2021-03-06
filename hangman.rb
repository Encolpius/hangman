class Hangman 

    require_relative 'game.rb'
    require 'yaml'
    require 'json'

    def initialize 
        puts 
        puts "+++++++++++++++++++++++++++".rjust(69)
        puts "Let's play Hangman!".rjust(65)
        puts "+++++++++++++++++++++++++++".rjust(69)
        puts
        puts "Game Options:".rjust(55)
        puts "1. New Game".rjust(53)
        puts "2. Load Game".rjust(54)
        puts "3. Exit".rjust(49)
        puts
        puts "What would you like to do?"
        choose_option
    end

    def choose_option 
        option = gets.chomp.downcase.strip.to_i
        if option == 1 
            puts "Starting a new game..."
            game = Game.new
            game.play
        elsif option == 2
            game = Game.new
            game.from_json
        elsif option == 3 
            exit
        else 
            puts "Invalid input." 
            choose_option
        end
    end
end
e = Hangman.new