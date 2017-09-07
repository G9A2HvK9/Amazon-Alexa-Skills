require 'Sinatra'

class App < Sinatra::Base

  post '/' do
    p request.body
  end

end
