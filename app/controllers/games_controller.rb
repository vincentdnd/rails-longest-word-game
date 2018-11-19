require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
    @start_time = Time.now
    #@comment = Comment.new(author: cookies[:score])
  end

  def score
    start_time = Time.parse(params[:start_time])
    stop_time = Time.now
    time_taken = stop_time - start_time
    @sum = 0
    @result = score_and_message(params[:name], params[:array], time_taken)
    score
    raise
  end

  private

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def compute_score(attempt, time_taken)

    time_taken > 60.0 ? 0 : attempt.size * (1.0 - time_taken / 60.0)
  end

  def run_game(attempt, grid, start_time, end_time)
    result = { time: end_time - start_time }

    score_and_message = score_and_message(attempt, grid, result[:time])
    result[:score] = score_and_message.first
    result[:message] = score_and_message.last

    result
  end

  def score_and_message(attempt, grid, time)
    if included?(attempt.upcase, grid)
      if english_word?(attempt)
        score = compute_score(attempt, time)
        [score, 'well done']
      else
        [0, 'not an english word']
      end
    else
      [0, 'not in the grid']
    end
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end

  def scores
    session[:score] = []
    session[:score] << @result[0]
    @scores = session[:score].inject(0){|sum,x| sum + x }
    @scores
  end
end
