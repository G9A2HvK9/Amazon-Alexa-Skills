require 'sinatra'
require 'json'
require 'imdb'

class Server < Sinatra::Base

  post '/' do
    parsed_request = JSON.parse(request.body.read)
    this_is_the_first_question = parsed_request["session"]["new"] || parsed_request["session"]["attributes"].empty?
    restart_requested = (parsed_request["request"]["intent"]["name"] == "AMAZON.StartOverIntent")

    p parsed_request["request"]["intent"]["name"] == "FollowUp"

    if restart_requested
      return{
        version: "1.0",
        sessionAttributes: {},
          response: {
            outputSpeech: {
              type: "PlainText",
              text: "Ok. Starting over. What movie would you like to know about?"
            },
          shouldEndSession: false
          }
        }.to_json
    end

    if this_is_the_first_question
      requested_movie = parsed_request["request"]["intent"]["slots"]["Movie"]["value"]
      movie_list = Imdb::Search.new(requested_movie).movies
      movie = movie_list.first
      return{
        version: "1.0",
        sessionAttributes: {
          movieTitle: requested_movie
        },
          response: {
            outputSpeech: {
              type: "PlainText",
              text: movie.plot_synopsis
            }
          }
        }.to_json
    end

    if parsed_request["request"]["intent"]["name"] == "FollowUp"
      movie_title = parsed_request["session"]["attributes"]["movieTitle"]
      movie_list = Imdb::Search.new(movie_title).movies
      movie = movie_list.first
      role = parsed_request["request"]["intent"]["slots"]["Role"]["value"]
      p role
      p movie.director.join
      p movie.cast_members.join(",")

      if role == "directed"
        response_text = "#{movie_title} was directed by #{movie.director.join}"
      end

      if role == "starred in"
        response_text = "#{movie_title} starred #{movie.cast_members.join(",")}"
      end


      return{
        version: "1.0",
        sessionAttributes: {
          movieTitle: movie_title
        },
        response: {
          outputSpeech: {
            type: "PlainText",
            text: response_text
          }
        }
      }.to_json
    end
  end


end
