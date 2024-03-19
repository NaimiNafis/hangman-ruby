# frozen_string_literal: true

# This class represents a Hangman game where a player tries to guess a secret word by
# suggesting letters within a certain number of guesses (which in this case = 6)
class Hangman
  FILENAME = 'google-10000-english-no-swears.txt'
  MAX_GUESSES = 6

  def initialize
    @dictionary = load_dictionary(FILENAME)
    @secret_word = @dictionary.sample
    @display_word = '_' * @secret_word.length
    @guess_count = MAX_GUESSES
  end

  def load_dictionary(filename)
    if File.exist?(filename)
      File.readlines(filename).map(&:chomp)
    else
      puts 'Dictionary file not found.'
      exit
    end
  end

  def greet_player
    puts 'Welcome to the hangman game!'
    puts @secret_word # For debugging purposes
  end

  def game_loop
    while @guess_count.positive? && @display_word != @secret_word
      display_game_state
      process_guess(player_guess)
    end
  end

  def conclude_game
    if @display_word == @secret_word
      puts "Congratulations, you won! The word was '#{@secret_word}'."
    else
      puts "Game over! The word was '#{@secret_word}'."
    end
  end

  def display_game_state
    puts "\nGuesses left: #{@guess_count}"
    puts "Word: #{@display_word}"
  end

  def player_guess
    loop do
      print 'Please enter 1 alphabet: '
      guess = gets.chomp.downcase
      return guess if guess.match?(/\A[a-z]\z/)

      puts 'Please enter only one alphabet character.'
    end
  end

  def process_guess(guess)
    if @secret_word.include?(guess)
      puts 'You are correct!'
      update_display_word(guess)
    else
      puts 'Incorrect guess.'
      draw_hangman(@guess_count)
      @guess_count -= 1
    end
  end

  def update_display_word(guess)
    @secret_word.chars.each_with_index do |char, index|
      @display_word[index] = char if char == guess
    end
  end

  def draw_hangman(guesses_left)
    stages = [
      ['  +---+', '  |   |', '      |', '      |', '      |', '      |', '========='],
      ['  +---+', '  |   |', '  O   |', '      |', '      |', '      |', '========='],
      ['  +---+', '  |   |', '  O   |', '  |   |', '      |', '      |', '========='],
      ['  +---+', '  |   |', '  O   |', ' /|   |', '      |', '      |', '========='],
      ['  +---+', '  |   |', '  O   |', ' /|\\  |', '      |', '      |', '========='],
      ['  +---+', '  |   |', '  O   |', ' /|\\  |', ' /    |', '      |', '========='],
      ['  +---+', '  |   |', '  O   |', ' /|\\  |', ' / \\  |', '      |', 'Game Over!']
    ]

    puts stages[MAX_GUESSES - guesses_left]
  end

  def start_game
    greet_player
    game_loop
    conclude_game
  end
end

hangman = Hangman.new
hangman.start_game
