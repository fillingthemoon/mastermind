require 'pry'

class Game
  attr_accessor :colours, :secret_colours, :feedback, :secret_code, :possible_com_answers

  def initialize
    @colours = ["red", "orange", "yellow", "green", "blue", "purple"]
    @feedback = ["black", "white"]
    @secret_colours = []
    @feedback = []
    @secret_code = shuffle_and_choose
    @possible_com_answers = []
  end

  def shuffle_and_choose
    self.secret_colours.clear
    4.times do |i|
      self.secret_colours.push(self.colours.shuffle[0])
    end
    self.secret_colours
  end

  def give_feedback
    puts ""
    print "Feedback: "
    p self.feedback.shuffle
    puts ""
  end

  def welcome_main
    puts "Welcome to Mastermind!"
    puts ""

    input = ""
    loop do
      puts "Would you like to be A) the creator or B) the guesser?"
      input = gets.chomp
      break if input.upcase == "A" || input.upcase == "B"
    end

    if input.upcase == "A"
      welcome_creator
    elsif input.upcase == "B"
      welcome_guesser
    end
  end

  def welcome_creator
    puts "Welcome creator!"
    puts ""
    puts "You will now choose a secret 4-colour secret code!"
    puts ""
    puts "The possible colours include: red, orange, yellow, green blue, purple"
    puts ""
    puts "The computer will receive some feedback after each guess:"
    puts "\"white\" means that they got one of the colours correct but it's in the wrong place."
    puts "\"black\" means that they got one of the colours correct and it's in thr correct place."
    puts ""
    start_creator
  end

  def welcome_guesser
    puts "Welcome guesser!"
    puts ""
    puts "The computer will now choose a secret 4-colour secret code!"
    puts ""
    puts "The possible colours include: red, orange, yellow, green blue, purple"
    puts ""
    puts "You will receive some feedback after each guess:"
    puts "\"white\" means that you got one of the colours correct but it's in the wrong place."
    puts "\"black\" means that you got one of the colours correct and it's in thr correct place."
    puts ""
    start_guesser
  end

  def start_creator
    puts "Create your 4-colour secret code. Please leave a space between each of the colours you choose."
    self.secret_code = gets.chomp.split(" ")

    12.times do |index|
      self.feedback = []
      puts ""
      puts "The computer will now guess your secret code"
      computer_guess = shuffle_and_choose
      if self.possible_com_answers.any? 
        self.possible_com_answers.each do |val| 
          computer_guess.push(val)
          computer_guess.shift
        end
      end
      computer_guess.shuffle
      puts "The computer guesses #{computer_guess}"
      puts ""

      if index == 11
        puts "Computer loses!"
        print "The answer is "
        p self.secret_code
        break
      end

      if computer_guess == self.secret_code
        puts "Computer wins!"
        print "The answer is "
        p self.secret_code
        break
      end

      puts "Now please provide the computer with some feedback"
      puts "Do you want to do this A) manually or B) automatically?"
      selection = gets.chomp

      feedback = ""
      if selection.upcase == "A"
        puts "Enter your feedback:"
        feedback = gets.chomp.split(" ") 
      elsif selection.upcase == "B"
        check_for_white(computer_guess)
        check_for_black(computer_guess)
        feedback = self.feedback.shuffle
      end
      puts "Your feedback: #{feedback}" 

      self.possible_com_answers = []
      computer_guess[0, self.feedback.length].each do |val|
        self.possible_com_answers.push(val)
      end

    end
  end

  def start_guesser
    12.times do |index|
      self.feedback = []
      puts "What is your guess? Please leave a space between each of the colours you guess."
      guess = gets.chomp.split(" ")

      check_for_white(guess)
      check_for_black(guess)
      give_feedback

      if index == 11
        puts "You lose!"
        print "The answer is "
        p self.secret_code
        break
      end

      if guess == self.secret_code 
        puts "You win!"
        print "The answer is "
        p self.secret_code
        break
      end
    end
  end

  def check_for_white(guess)
    dup_guess = guess.dup

    self.secret_code.each do |secret_colour|
      dup_guess.each_with_index do |guess_colour, i|
        if secret_colour == guess_colour
          dup_guess.delete_at(dup_guess.index(guess_colour))
          self.feedback.push("white")
          break
        end
      end
    end
  end

  def check_for_black(guess)
    self.secret_code.each_with_index do |colour, i|
      if self.secret_code[i] == guess[i]
        self.feedback.delete_at(self.feedback.index("white"))
        self.feedback.push("black")
      end
    end
  end
end

new_game = Game.new
new_game.welcome_main
