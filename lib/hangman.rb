FILENAME = 'google-10000-english-no-swears.txt'

if File.exist?(FILENAME)
  dictionary = File.readlines(FILENAME).map(&:chomp)
else
  puts "Dictionary file not found."
  exit
end

secret_word = dictionary.sample
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
    guess_count -= 1
  end

  if display_word == secret_word
    puts "Congratulations, you won! The word was '#{secret_word}'."
    exit
  end
end

puts "Game over! The word was '#{secret_word}'."
