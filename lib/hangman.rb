# frozen_string_literal: true

require 'yaml'

# BasicSerializable provides serialization capabilities for classes.
# It uses YAML as the serialization format.
module BasicSerializable
  @serializer = YAML

  class << self
    attr_accessor :serializer
  end

  def serialize
    obj = instance_variables.each_with_object({}) do |var, acc|
      acc[var] = instance_variable_get(var)
    end

    self.class.serializer.dump(obj)
  end

  def unserialize(string)
    obj = self.class.serializer.load(string)
    obj.each_key do |key|
      instance_variable_set(key, obj[key])
    end
  end
end

# This class represents a Hangman game where a player tries to guess a secret word by
# suggesting letters within a certain number of guesses.
class Hangman
  include BasicSerializable

  FILENAME = 'google-10000-english-no-swears.txt'
  SAVE_FILENAME = 'output/save_game.yml'
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
    display_game_state
    if @display_word == @secret_word
      puts "Congratulations, you won! 🎉 The word was '#{@secret_word}'."
    else
      puts "Game over! 😢 The word was '#{@secret_word}'."
    end
  end

  def display_game_state
    puts "\nGuesses left: #{@guess_count}"
    puts "Word: #{@display_word}"
  end

  def player_guess
    print 'Your guess (or type "save" to save, "load" to load): '
    loop do
      input = gets.chomp.downcase.strip
      case input
      when 'save', 'load'
        handle_special_input(input)
      when /\A[a-z]\z/
        return input
      else
        puts 'Invalid input. Please enter a single letter or "save"/"load":'
      end
    end
  end

  def handle_special_input(input)
    case input
    when 'save'
      save_game
    when 'load'
      load_game
      display_game_state
    end
  end

  def save_game
    Dir.mkdir('output') unless Dir.exist?('output')
    save_id = Time.now.to_i
    save_filename = "output/save_#{save_id}.yml"
    serialized_state = serialize
    File.open(save_filename, 'w') { |file| file.write(serialized_state) }
    puts "Game saved successfully with ID: #{save_id}"
  end

  def load_game
    puts 'Available saves:'
    saves = Dir.glob('output/save_*.yml')
    saves.each_with_index do |filename, index|
      puts "#{index + 1}. #{filename}"
    end

    choice = nil
    until choice
      print 'Enter the number (1-4 digits) of the save to load: '
      input = gets.chomp
      if input.match?(/\A\d{1,4}\z/)
        choice = input.to_i
        if choice < 1 || choice > saves.length
          puts "Invalid selection. Please select a number between 1 and #{saves.length}."
          choice = nil
        end
      else
        puts 'Invalid input. Please enter a 1 to 4-digit number.'
      end
    end

    save_filename = saves[choice - 1]
    if File.exist?(save_filename)
      serialized_state = File.read(save_filename)
      unserialize(serialized_state)
      puts 'Game loaded successfully!'
    else
      puts 'Save file not found.'
    end
  end

  def process_guess(guess)
    if @secret_word.include?(guess)
      puts 'You are correct!'
      update_display_word(guess)
    else
      puts 'Incorrect guess.'
      @guess_count -= 1
    end
    draw_hangman
  end

  def update_display_word(guess)
    @secret_word.chars.each_with_index do |char, index|
      @display_word[index] = char if char == guess
    end
  end

  def draw_hangman
    stages = [
      ['  +---+', '  |   |', '      |', '      |', '      |', '      |', '========='],
      ['  +---+', '  |   |', '  O   |', '      |', '      |', '      |', '========='],
      ['  +---+', '  |   |', '  O   |', '  |   |', '      |', '      |', '========='],
      ['  +---+', '  |   |', '  O   |', ' /|   |', '      |', '      |', '========='],
      ['  +---+', '  |   |', '  O   |', ' /|\\  |', '      |', '      |', '========='],
      ['  +---+', '  |   |', '  O   |', ' /|\\  |', ' /    |', '      |', '========='],
      ['  +---+', '  |   |', '  O   |', ' /|\\  |', ' / \\  |', '      |', 'Game Over!']
    ]

    puts stages[MAX_GUESSES - @guess_count]
  end

  def start_game
    greet_player
    game_loop
    conclude_game
  end
end

hangman = Hangman.new
hangman.start_game
