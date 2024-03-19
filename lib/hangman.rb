FILENAME = 'google-10000-english-no-swears.txt'
dictionary = []

if File.exist?(FILENAME)
  dictionary = File.readlines(FILENAME).map(&:chomp)
else
  puts "Dictionary file not found."
  exit
end

def draw_hangman(guesses_left)
  case guesses_left
  when 6
    puts "-------"
    puts "|     |"
    puts "|"
    puts "|"
    puts "|"
    puts "|"
    puts "|"
  when 5
    puts "-------"
    puts "|     |"
    puts "|     O"
    puts "|"
    puts "|"
    puts "|"
    puts "|"
  when 4
    puts "-------"
    puts "|     |"
    puts "|     O"
    puts "|     |"
    puts "|"
    puts "|"
    puts "|"
  when 3
    puts "-------"
    puts "|     |"
    puts "|     O"
    puts "|    /|"
    puts "|"
    puts "|"
    puts "|"
  when 2
    puts "-------"
    puts "|     |"
    puts "|     O"
    puts "|    /|\\"
    puts "|"
    puts "|"
    puts "|"
  when 1
    puts "-------"
    puts "|     |"
    puts "|     O"
    puts "|    /|\\"
    puts "|    /"
    puts "|"
    puts "|"
  when 0
    puts "-------"
    puts "|     |"
    puts "|     O"
    puts "|    /|\\"
    puts "|    / \\"
    puts "|"
    puts "|"
    puts "Game Over!"
  end
end

secret_word = dictionary.sample
puts secret_word
display_word = "_" * secret_word.length
guess_count = 6

puts "Welcome to the hangman game!"

while guess_count > 0
  puts "\nGuesses left: #{guess_count}"
  puts "Word: #{display_word}"
  print "Please enter 1 alphabet: "
  guess = gets.chomp.downcase

  unless guess.match?(/\A[a-z]\z/)
    puts "Please enter only one alphabet character."
    next
  end

  if secret_word.include?(guess)
    puts "You are correct!"
    secret_word.chars.each_with_index do |char, index|
      display_word[index] = char if char == guess
    end
  else
    puts "Incorrect guess."
    draw_hangman(guess_count)
    guess_count -= 1
  end

  if display_word == secret_word
    puts "Congratulations, you won! The word was '#{secret_word}'."
    exit
  end
end

puts "Game over! The word was '#{secret_word}'."
