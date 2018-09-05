class Game

    def initialize 
        puts 
        puts "+++++++++++++++++++++++++++".rjust(69)
        puts "Let's play Hangman!".rjust(65)
        puts "+++++++++++++++++++++++++++".rjust(69)
        puts
        @guesses_left = 6
        @correct_guesses = []
        @incorrect_guesses = []
        @word = choose_word
    end

    def play 
        loop do 
            game_over? || is_winner?
            player_guess
            check_for_letter
        end
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

    def player_guess 
        print "Guesses left: #{@guesses_left}. Choose a letter: "
        player_choice = gets.chomp.downcase.strip 
        @guess = player_choice
        legal_player_guess?(player_choice)
    end

    def legal_player_guess?(letter) 
        if @correct_guesses.include?(@guess) 
            puts "The letter is already in the word:"
        elsif @incorrect_guesses.include?(@guess) || letter.match(/[^a-z]/) || letter.size > 1 
           puts "Invalid entry. Please guess again."
           player_guess
        end
    end

    def check_for_letter
        if @word.include?(@guess)
            @correct_guesses.push(@guess)
            update_word
        else 
            puts ["Nope", "Nada", "Nah", "Womp womp", "Narp"].sample
            @incorrect_guesses.push(@guess)
            @guesses_left -= 1
        end
    end

    def update_word 
        @word.split('').each_with_index { |el, i| el == @guess ? @mystery_word[i] = el : el}
        puts @mystery_word.rjust(60)
    end

    def is_winner? 
        if !@mystery_word.include?("_")
            puts "YOU'VE WON!"
            exit
        end
    end

    def game_over? 
        if @guesses_left == 0
            puts "The word was: #{@word}. Better luck next time!"
            exit 
        else 
            false
        end
    end
end