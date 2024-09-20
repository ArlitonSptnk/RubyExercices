require 'set'

n = gets.to_i
lst = nil

for i in 0...n
	buff = gets.to_i	
	if(lst != buff)
     	lst = buff
        puts lst
    end
        
end

