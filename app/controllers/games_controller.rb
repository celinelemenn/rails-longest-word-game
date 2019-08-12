require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    alphabet_array = ('A'..'Z').to_a
    @letters = 10.times.map { alphabet_array.sample }
    @start_time = Time.now
  end

  def score
    @input = params[:input]
    @letters = params[:grid]
    start_time = params[:start_time].to_datetime
    end_time = Time.now

    url = "https://wagon-dictionary.herokuapp.com/#{@input}"
    @hash_answer = JSON.parse(open(url).read)
    if @hash_answer["found"] == true
      if @input.upcase.split("").sort.all? { |letter| @input.upcase.count(letter) <= @letters.split(" ").count(letter) }
        @hash_answer[:message] = "Congratulation! #{@input} is a valid english word"
        # @hash_answer[:score] = 0
      @hash_answer[:score] = @input.length * 10 - ((end_time - start_time).to_i)
      else @hash_answer = { message: "Sorry but #{@input} can't be built out of #{@letters}", score: 0 }
      end
    else @hash_answer = { message: "Sorry but #{@input} does not seem to be an english word...", score: 0 }
    end
    @hash_answer
  end
end
