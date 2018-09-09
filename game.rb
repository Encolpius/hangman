class Game

    attr_accessor :guesses_left, :correct_guesses, :incorrect_guesses, :word, :mystery_word
    def initialize
        @guesses_left = 6
        @correct_guesses = Array.new
        @incorrect_guesses = Array.new
        @word = choose_word
        @guess = ""
    end

    def to_json(*options) 
        as_json(*options).to_json(*options)
    end

    def as_json(options={})
        {
            guesses_left: @guesses_left,
            correct_guesses: @correct_guesses,
            incorrect_guesses: @incorrect_guesses,
            mystery_word: @mystery_word,
            word: @word,
            guess: @guess
        }
    end

    def serialize 
        data = self.to_json
        Dir.mkdir("savedgames") unless Dir.exists? "savedgames"
        File.file?('savedgames/saved_1.txt') ? new_save_state(data) : savedgame = File.new("savedgames/saved_1.txt", 'w')
    end

    def new_save_state(data)
        current_file = Dir['savedgames/*'][-1].match(/[\d]/)[0].to_i
        savedgame = File.new("savedgames/saved_#{current_file+1}.txt", 'w')
        savedgame.write(data)
    end

    def choose_word 
        contents = File.readlines('5desk.txt')
        random_choice = contents[Random.new.rand(contents.length)].downcase.strip
        @mystery_word = "_" * random_choice.size
        random_word_legal?(random_choice)
    end

    def random_word_legal?(word)
        word.length.between?(5, 12) ? word : choose_word
    end

    def play 
        loop do
            game_over? || is_winner?
            player_guess
            check_for_letter
        end
    end

    def player_guess
        print "Guesses left: #{guesses_left}. Choose a letter: "
        player_choice = gets.chomp.downcase.strip 
        @guess = player_choice
        legal_player_guess?(player_choice)
    end

    def legal_player_guess?(letter) 
        if @guess == "save"
            puts "Saving and exiting game..."
            serialize
            exit
        elsif correct_guesses.include?(@guess) 
            puts "The letter is already in the word:"
        elsif letter.match(/[^a-z]/) || incorrect_guesses.include?(@guess) || letter.size > 1 
           puts "Invalid entry. Please guess again."
           player_guess
        end
    end

    def check_for_letter
        if word.include?(@guess)
            correct_guesses.push(@guess)
            update_word
        else 
            puts ["Nope", "Nada", "Nah", "Womp womp", "Narp"].sample
            incorrect_guesses.push(@guess)
            @guesses_left -= 1
        end
    end

    def update_word 
        word.split('').each_with_index { |el, i| el == @guess ? @mystery_word[i] = el : el}
        puts @mystery_word.rjust(60)
    end

    def game_over? 
        if @guesses_left == 0
            puts "You lost! The word was #{word.upcase}. Better luck next time!".rjust(88)
            exit 
        else 
            false
        end
    end

    def is_winner? 
        if !@mystery_word.include?("_")
            puts "YOU'VE WON!!".rjust(65)
            exit
        end
    end

    def from_json
        choice = choose_save_game
        puts choice
        File.open(choice, 'r') do |f| 
            f.each_line do |line|
                data = JSON.parse(line)
                data.each_with_index do |el, i| 
                    self.instance_variable_set(self.instance_variables[i], el[1])
                end
            end
        end
        play
    end

    def choose_save_game 
        puts "Choose an option from the list of saved games!"
        Dir["savedgames/*"].each_with_index do |file, i|
            puts "#{i}. #{file}"
        end
        choice = gets.chomp.strip.to_i
        Dir["savedgames/*"][choice]
    end
end