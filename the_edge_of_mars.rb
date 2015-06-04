module TheEdgeOfMars
  LOST_ROBOTS_COORDS = []
  WORLD_DIRECTIONS = ["N", "E", "S", "W"]

  class Robot
    attr_accessor :last_x, :x, :last_y, :y, :direction, :lost_x, :lost_y

    def initialize(x , y, direction)
      @last_x = x
      @x = x
      @last_y = y
      @y = y
      @direction = direction
      @lost_x = nil
      @lost_y = nil
    end

    def current_position
      [x, y]
    end

    def turn_left
      @direction = case direction
        when "N"
          "W"
        when "E"
          "N"
        when "S"
          "E"
        when "W"
          "S"
        end
    end

    def turn_right
      @direction = case direction
        when "N"
          "E"
        when "E"
          "S"
        when "S"
          "W"
        when "W"
          "N"
        end
    end

    def go_forward
      @last_x = x
      @last_y = y

      case direction
      when "N"
        @y += 1
      when "E"
        @x += 1
      when "S"
        @y -= 1
      when "W"
        @x -= 1
      end
    end

    def looser!
      @lost_x = last_x
      @lost_y = last_y
    end

    def already_lost?
      lost_x != nil && lost_y != nil
    end

    def out_of_boundaries_of?(mars)
      x > mars.end_x || x < mars.start_x || y > mars.end_y || y < mars.start_y
    end
  end

  class Mars
    attr_accessor :end_x, :end_y

    def initialize(end_x, end_y)
      @end_x = end_x
      @end_y = end_y
    end

    def start_x
      0
    end

    def start_y
      0
    end
  end

  class Game
    attr_accessor :mars

    def initialize
      Printer::Info.author

      setup
      Printer::Info.setup_complete

      play
    end

    def setup
      Printer::Info.provide_right_edge_coords
      mars_coords = InputParser.mars_coordinates

      @mars = Mars.new(*mars_coords)
    end

    def play
      while true do
        Printer::Info.provide_instructions_for_robot

        start_position = InputParser.robot_start_position
        robot = Robot.new(*start_position)

        instructions = InputParser.robot_instructions

        Operations.final_position(mars, robot, instructions)

        Printer::Info.results(robot)
      end
    end
  end

  module Operations
    def self.final_position(mars, robot, instructions)
      instructions.each do |instruction|
        case instruction
        when "L"
          robot.turn_left
        when "R"
          robot.turn_right
        when "F"
          if safe_position?(mars, robot)
            robot.go_forward

            if robot.out_of_boundaries_of?(mars)
              unless robot.already_lost?
                robot.looser!
                add_lost_coords(robot)
              end
            end
          end
        end
      end
    end

    def self.add_lost_coords(robot)
      LOST_ROBOTS_COORDS.push [robot.lost_x, robot.lost_y]
    end

    def self.safe_position?(mars, robot)
      unsafe_position = LOST_ROBOTS_COORDS.find do |coords|
        robot.current_position == coords
      end

      if unsafe_position
        temp_robot = robot.dup
        temp_robot.go_forward

        return false if temp_robot.out_of_boundaries_of?(mars)
      end

      true
    end
  end

  module InputParser
    COORD_MAX = 50
    INPUT_LENGTH_MAX = 100
    VALID_INSTRUCTIONS = ["L", "R", "F"]

    def self.input
      begin
        input = gets.chomp

        exit if input == "exit"

        input_length_invalid = input.length > INPUT_LENGTH_MAX

        Printer::Errors.input_too_long if input_length_invalid
      end while input_length_invalid

      input
    end

    def self.robot_start_position
      begin
        input = InputParser.input

        coords = input.split(" ")
        x = coords[0].to_i
        y = coords[1].to_i
        direction = coords.last.upcase

        coords_length_invalid = x > InputParser::COORD_MAX || y > InputParser::COORD_MAX
        direction_invalid = !WORLD_DIRECTIONS.include?(direction)

        Printer::Errors.coordinate_too_far if coords_length_invalid
        Printer::Errors.direction_invalid if direction_invalid
      end while coords_length_invalid || direction_invalid

      [x, y, direction]
    end

    def self.robot_instructions
      begin
        input = InputParser.input.upcase.split("")

        input_invalid = input.find { |char| !VALID_INSTRUCTIONS.include?(char) }

        Printer::Errors.robot_instructions_invalid if input_invalid
      end while input_invalid

      input
    end

    def self.mars_coordinates
      begin
        input = InputParser.input

        coords = input.split(" ")
        x = coords.first.to_i
        y = coords.last.to_i
        coords_length_invalid = x > COORD_MAX || y > COORD_MAX

        Printer::Errors.coordinate_too_far if coords_length_invalid
      end while coords_length_invalid

      [x, y]
    end
  end

  module Printer
    module Info
      def self.author
        puts "--------Edge of The Mars--------"
        puts "Coding challenge"
        puts "Maciej Palinski - github.com/palin"
        puts "HINT: To exit at any point type `exit`"
        puts "--------------------------------\n\n"
      end

      def self.provide_right_edge_coords
        puts "Please provide coordinates for the top-right edge of Mars..."
      end

      def self.setup_complete
        puts "Mars is ready!"
      end

      def self.provide_instructions_for_robot
        puts "Please provide instructions for robots..."
      end

      def self.results(robot)
        lost = robot.already_lost? ? "LOST" : ""

        puts "Robot final position: "
        puts "#{robot.x} #{robot.y} #{robot.direction} #{lost}\n"
      end
    end

    module Errors
      def self.input_too_long
        puts "Max length of input is #{InputParser::INPUT_LENGTH_MAX}! Please try again..."
      end

      def self.coordinate_too_far
        puts "Max coordinate value is #{InputParser::COORD_MAX}! Please try again..."
      end

      def self.direction_invalid
        puts "Direction is invalid! You can use N, E, S, W only..."
      end

      def self.robot_instructions_invalid
        puts "Instructions are invalid! You can use L, R, F only..."
      end
    end
  end
end
