require 'Sinatra'
require 'json'
require 'net/http'

class Server < Sinatra::Base

  post '/' do
    {
      version: "1.0",
      response: {
        outputSpeech: {
            type: "PlainText",
            text: "42 is... meh... ok"
          }
      }
    }.to_json
  end

end
