class Game

  def initialize
    @word = get_the_word
    @tries = 6
    @misses = []
    @hits = []
    take_turn
  end

  # First filters the words array created from '5desk.txt', then
  # gives back an array containing a word
  def get_the_word
    words = File.readlines("5desk.txt")
    words = words.map do |word|
      word.strip
    end
    words = words.select do |word|
      (word.length > 4) && (word.length < 13)
    end
    words.sample.upcase.split("")
  end

  def hide_word
    hidden = @word.map do |e|
      if @hits.include? e
        e
      else
        e = "_"
      end
    end
    hidden
  end

  def take_turn
    until game_over? || victory?
      show_gallows
      puts "Word:   #{hide_word.join(' ')}"
      puts "Misses: #{@misses.join(', ')}"
      check_guess guess
    end
    show_gallows
    puts "Word:   #{hide_word.join(' ')}"
    puts "You have lost." if game_over?
    puts "You are victorious!" if victory?
  end

  def show_gallows
    puts case @tries
    when 6
      ['   ____', '   |  |', '      |', '      |', '      |', '      |', '______|']
    when 5
      ['   ____', '   |  |', '   O  |', '      |', '      |', '      |', '______|']
    when 4
      ['   ____', '   |  |', '   O  |', '   |  |', '   |  |', '      |', '______|']
    when 3
      ['   ____', '   |  |', '   O  |', '  /|  |', '   |  |', '      |', '______|']
    when 2
      ['   ____', '   |  |', '   O  |', '  /|\ |', '   |  |', '      |', '______|']
    when 1
      ['   ____', '   |  |', '   O  |', '  /|\ |', '   |  |', '  /   |', '______|']
    when 0
      ['   ____', '   |  |', '   O  |', '  /|\ |', '   |  |', '  / \ |', '______|']
    end
  end

  # need to check the input
  def guess
    guess = ""
    until (guess.length == 1)&&(!@hits.include? guess)&&(!@misses.include? guess)
      if guess.length > 1
        puts "You can guess one letter at a time."
      elsif (@hits.include? guess) || (@misses.include? guess)
        puts "You already tried that letter."
      end
      print "Your guess: "
      guess = gets.chomp.upcase
    end
    guess
  end

  def check_guess(letter)
    if @word.include? letter
      @hits << letter
    else
      @misses << letter
      @tries -= 1
    end
  end

  def game_over?
    @tries == 0
  end

  def victory?
    hide_word == @word
  end
end

Game.new
