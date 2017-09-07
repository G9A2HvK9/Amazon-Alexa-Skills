require 'sinatra'
require 'json'

class Server < Sinatra::Base

  post '/' do
    parsed_request = JSON.parse(request.body.read)
    p parsed_request

    return{
      versio: "1.0",
      response: {
        outputSpeech: {
          type: "PlainText",
          text: "This is the first question"
        }
      }
    }.to_json
  end


end
