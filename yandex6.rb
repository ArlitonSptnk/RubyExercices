require "set"

n = gets.to_i

cities = []

n.times {
  cities << gets.split(' ').map(&:to_i)
}
fuel = gets.to_i

start_c, end_c = gets.split(' ').map(&:to_i)
start_c -= 1; end_c -= 1

def distance(coord1, coord2)
    return (coord1[0] - coord2[0]).abs + (coord1[1] - coord2[1]).abs
end

def bfs(start_i, end_i, cities, fuel)
  queue = []
  visited = Set.new

  queue.push([start_i, 0])

  while (queue.length > 0) 
    curr_i, curr_c = queue.shift

    if curr_i == end_i
      return curr_c
    end

    for i in 0...cities.size
        if !visited.include?(i) && distance(cities[curr_i], cities[i]) <= fuel
          queue.push([i, curr_c + 1])
          visited.add(i)
        end
    end
  end
  return -1
end

puts bfs(start_c, end_c, cities, fuel)