class Hangman
  FILENAME = 'google-10000-english-no-swears.txt'
  MAX_GUESSES = 6

  def initialize
    @dictionary = load_dictionary(FILENAME)
    @secret_word = @dictionary.sample
    @display_word = "_" * @secret_word.length
    @guess_count = MAX_GUESSES
  end

  def load_dictionary(filename)
    if File.exist?(filename)
      File.readlines(filename).map(&:chomp)
    else
      puts "Dictionary file not found."
      exit
    end
  end

  def draw_hangman
    stages = [
      ["  +---+", "  |   |", "      |", "      |", "      |", "      |", "========="],
      ["  +---+", "  |   |", "  O   |", "      |", "      |", "      |", "========="],
      # Other stages omitted for brevity...
    ]
    puts stages[MAX_GUESSES - @guess_count]
  end

  def update_display_word(guess)
    @secret_word.chars.each_with_index do |char, index|
      @display_word[index] = char if char == guess
    end
  end

  def start_game
    puts "Welcome to the hangman game!"
    puts @secret_word # For debugging purposes

    while @guess_count > 0
      puts "\nGuesses left: #{@guess_count}"
      puts "Word: #{@display_word}"
      print "Please enter 1 alphabet: "
      guess = gets.chomp.downcase

      unless guess.match?(/\A[a-z]\z/)
        puts "Please enter only one alphabet character."
        next
      end

      if @secret_word.include?(guess)
        puts "You are correct!"
        update_display_word(guess)
      else
        puts "Incorrect guess."
        draw_hangman
        @guess_count -= 1
      end

      if @display_word == @secret_word
        puts "Congratulations, you won! The word was '#{@secret_word}'."
        exit
      end
    end

    puts "Game over! The word was '#{@secret_word}'."
  end
end

hangman = Hangman.new
hangman.start_game
