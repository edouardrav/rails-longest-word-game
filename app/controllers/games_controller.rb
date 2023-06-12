require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    alphabet = ("A".."Z").to_a
    @letters = []
    10.times { @letters << alphabet.sample }
  end

  def score
    @word = params[:word]
    @letters = params[:letters].split
    letters_check = @letters.clone
    @word.upcase.chars.each do |letter|
      if letters_check.include? letter
        index = letters_check.find_index { |l| l == letter }
        letters_check.delete_at(index)
      end
    end
    if letters_check.length == 10 - @word.length && valid?(@word)
      @result = { score: @word.length ** 2 }
    elsif letters_check.length == 10 - @word.length && !valid?(@word)
      @result = { score: 0, message: "unvalid" }
    else
      @result = { score: 0, message: "wrong letters" }
    end
  end

  private

  def valid?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    uri_open = URI.open(url).read
    json = JSON.parse(uri_open)
    json["found"]
  end
end
