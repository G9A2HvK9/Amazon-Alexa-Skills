require 'sinatra'
require 'json'
require 'imdb'

class Server < Sinatra::Base

  post '/' do
    parsed_request = JSON.parse(request.body.read)
    movie_facts_intent = (parsed_request["request"]["intent"]["name"] == "MovieFacts")
    follow_up_intent = (parsed_request["request"]["intent"]["name"] == "FollowUp")
    start_over_intent = (parsed_request["request"]["intent"]["name"] == "AMAZON.StartOverIntent")

    if start_over_intent
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

    if movie_facts_intent
      requested_movie = parsed_request["request"]["intent"]["slots"]["Movie"]["value"]
      movie = Imdb::Search.new(requested_movie).movies.first

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

    if follow_up_intent
      movie_title = parsed_request["session"]["attributes"]["movieTitle"]
      movie = Imdb::Search.new(movie_title).movies.first
      role = parsed_request["request"]["intent"]["slots"]["Role"]["value"]

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
