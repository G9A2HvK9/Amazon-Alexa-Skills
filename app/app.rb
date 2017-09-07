require 'Sinatra'

class App < Sinatra::Base

  post '/' do
    { version: "1.0",
      response:{
        outputSpeech: {
          type: "PlainText",
          text: "Hello World!"
        }
      }
    }.to_json
  end

end
