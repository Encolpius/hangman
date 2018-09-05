class Hangman

    def initialize 
        puts "Let's play Hangman! Picking a file from the Dictionary..."
        $contents = File.readlines('5desk.txt')
        @correct_picks = []
    end

    def choose_word
        word = $contents[Random.new.rand($contents.length)].downcase.strip
        legal_word?(word)
        @correct_picks = "_" * word.length
        play_game(word)
    end

    def legal_word?(word)
        word.length.between?(5, 12) ? word : choose_word
    end

    def play_game(word)
        @countdown = 6
        loop do 
            game_over?
            guess = player_guess
            check_for_letter(word, guess)
        end
    end

    def player_guess 
        print @countdown == 1 ? "You have #{@countdown} guess left! " : "You have #{@countdown} guesses left. "
        print "Choose a letter: "
        guess = gets.chomp.downcase.strip
        legal_guess?(guess)
        guess
    end

    def legal_guess?(letter)
        if letter.match(/[^a-z]/) || letter.size > 1
            puts "Invalid entry."
            player_guess
        end
    end

    def check_for_letter(word, letter)
        if word.include?(letter)
            update_word(word, letter)
        else 
            puts "Sorry, try again!"
            @countdown -= 1
        end
    end

    def update_word(word, letter)
        print word
    end

    def game_over?
        if @countdown == 0 
            puts "Bummer, man..."
            exit
        end
    end

end

w = Hangman.new
w.choose_word