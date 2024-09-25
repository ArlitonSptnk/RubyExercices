
module GreedGame
  # Exceptions
  class GameError < StandardError
  end

  # Console
  module GameConsole
    class << self
      def printMenu
        puts %{
Welcome you in GreedGame
What is amount of players?}
      end
      
      def printTurn (player_index, points)
        puts %{
-- Player #{player_index}, points: #{points} --
Do you want to roll dice?}
      end
    
      def printWinner (player_index)
        puts %{
-- Player #{player_index} --
You win!!! Congratulations!!!}
      end

      def printTurnResult(dices, score)
        puts %{
Result: #{dices}, score: #{score}}
      end

      def printFinalTurn
        puts %{
      It's a mega super FINAL!}
      end

      def get_string
        return gets
      end
    
      def get_int
        value = gets.chomp
        if !value.match(/\A\d+\Z/)
          return nil
        else
          return value.to_i
        end  
      end
    end
  end

  # Game 
  class DiceSet
    attr_reader :values, :score, :non_scoring_dice_number
    
    def initialize
      @values = []
      @random = Random.new
      @score = 0
      @non_scoring_dice_number = 0
    end

    def roll(num)
      @values = []
      num.times {
        @values << @random.rand(6) + 1
      }
      @score, @non_scoring_dice_number = self.get_score
    end

private
    def get_score
      numbers = [0] * 7
      @values.each {|num|
        numbers[num] += 1
      }
      
      score = 0
      
      for i in 1..6
        while numbers[i] >= 3
          if i == 1
            numbers[1] -= 3
            score += 1000
          else
            numbers[i] -= 3
            score += 100 * i
          end
        end
      end
      
      while numbers[1] > 0
        numbers[1] -= 1
        score += 100
      end
      
      while numbers[5] > 0
        numbers[5] -= 1
        score += 50
      end
    
      non_scoring_dice_number = 0

      numbers.each {|x|
        non_scoring_dice_number += x
      }

      return score, non_scoring_dice_number
    end


  end

  class Player
    attr_reader :points, :id
    
    def initialize(id, dice_set)
      @id = id
      @dice_set = dice_set

      @points = 0
      @buffer = 0
      @first_flag = false
    end

    def make_turn
      if self.can_roll? | !@first_flag 
        score, __ = @dice_set.roll(@first_flag ? @dice_set.non_scoring_dice_number : 5)
        return :lose_turn if score == 0
        @first_flag = true 
        @buffer += score
        return :next_turn
      else
        return :error_turn
      end
    end

    def can_roll?
      return @dice_set.score > 0
    end

    def end_turn
      if self.can_roll?
        @points += @buffer
        @buffer = 0
      end
      @first_flag = false 
    end

    def check?
      return @points >= 3000
    end
  private
    def add_points(points)
      raise GameError, 'Incorrect number of points, must be >= 0' unless points < 0

      @points += points
    end
  end

  class Game
    attr_reader :game_state

    def initialize(num_players = 2)
      raise GameError, "Incorrect num_player, must be >= 2" unless num_players >= 2  
      
      @players = []
      @current_player = 0
      @game_state = :default_game_state
      @dice_set = DiceSet.new
      
      for id in 1..num_players do
        @players << Player.new(id, @dice_set)
      end

      @game_state = :menu_game_state
    end

    def update
      begin
        case @game_state
          when :menu_game_state
            self.menu
            @game_state = :turn_game_state

          when :turn_game_state
            # Make some turns
            while self.turn(false) != :final_turn
            end
            # Last turn
            GameConsole::printFinalTurn
            while self.turn(true) != :final_turn
            end
            
            self.final
            @game_state = :end_game_state

        end
      rescue => ex
          puts ex.message
          return :update_error
      end
      return :update_okey
    end
private

    def menu
      GameConsole::printMenu()
      while !(value = GameConsole::get_int()) || value < 2
        puts "You must write a positive number > 1..."
      end
    end

    def turn (check = false)
      GameConsole::printTurn(@players[@current_player].id, @players[@current_player].points)
      
      response = GameConsole::get_string

      if response.downcase.chomp == 'yes'
        result = @players[@current_player].make_turn()
        
        GameConsole::printTurnResult(@dice_set.values, @dice_set.score)  
        if result == :next_turn
          return :next_turn
        end
      end
      
      @players[@current_player].end_turn()
      if check && @current_player + 1 == @players.size
        return :final_turn
      end

      @current_player = (@current_player + 1) % @players.size
      # Check for final
      if !check
        return :final_turn if @players[@current_player].check?  
      end
      return :next_turn
    end

    def final
      GameConsole::printFinalTurn

      winner = @players[0]
      for i in 1...@players.size do
          if winner.points < @players[i].points 
            winner = @players[i]
          end
      end
      
      GameConsole::printWinner(winner.id)
    end
  end
end
# Start game
if __FILE__ == $0
  game_instance = GreedGame::Game.new
  while game_instance.update() == :update_okey && game_instance.game_state != :end_game_state
  end
end
