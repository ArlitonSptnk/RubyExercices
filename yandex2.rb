n = gets.to_i

mx_len = 0

cur_len = 0

for i in 0...n
	val = gets.to_i
    if val == 1
    	cur_len += 1
    else
    	if mx_len < cur_len
        	mx_len = cur_len
        end
        cur_len = 0
    end
end

if(cur_len > mx_len)
	puts cur_len
else
	puts mx_len    
end

