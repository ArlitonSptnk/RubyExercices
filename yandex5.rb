first = gets
second = gets

hash_chars = {}
hash_chars.default = 0
count = 0
otv = 1

first.each_char do |ch|
  hash_chars[ch] += 1
  count += 1
end

second.each_char do |ch|
  hash_chars[ch] -= 1
  if hash_chars[ch] < 0
    otv = 0
    break
  end
  count -= 1
end

if count != 0
  otv = 0
end

puts otv



