
require 'set'
n = gets.to_i

stack = []

stack.push(['', 0, 0])

otv = []

while !stack.empty?
	string, left, right = stack.pop
	if(left == n && right == n)
		otv << string
	elsif(string.length < n * 2)
		if left < n
			stack.push(["#{string}(", left + 1, right])
		end	
		if right < left
			stack.push(["#{string})", left, right + 1])
		end
	end
end

puts otv.reverse


