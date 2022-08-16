require "open-uri"

class GameController < ApplicationController

  def new
    @letters = generate_grid(10)
  end

  def score
    @letters = params[:letters].split
    @word = params[:word]
    @message = run_game(@word, @letters)
  end

  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    (0...grid_size).map { ('A'..'Z').to_a[rand(26)] }
  end

  def word_checker(attempt, grid)
    attempt_compare = attempt.upcase.chars
    check = true
    attempt_compare.each do |letter|
      check = false unless grid.include? letter
      check = false unless attempt_compare.count(letter) <= grid.count(letter)
    end
    check
  end

  def run_game(attempt, grid)
    # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    user_serialized = URI.open(url).read
    data = JSON.parse(user_serialized)

    if data['found'] && word_checker(attempt, grid)
      "Congratulations! #{attempt.upcase} is a valid english word!"
    elsif word_checker(attempt, grid) == false
      "Sorry but #{attempt.upcase} can't be built out of #{grid.join(', ')}"
    else
      "Sorry but #{attempt.upcase} does not seem to be an english word"
    end
  end
end
