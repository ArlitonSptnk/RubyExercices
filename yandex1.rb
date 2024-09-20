keys_word, word = gets.chomp, gets.chomp

otv = 0

word.each_char { |ch|
	if(keys_word.include?(ch))
    	otv += 1
    end
}
puts otv

