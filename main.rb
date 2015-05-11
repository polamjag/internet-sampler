require 'bundler/setup'

require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra-websocket'

require 'slim'

set :server, 'thin'
set :sockets, []

tracks = {
  emoi: "/Users/satoru/Dropbox/00_WIP/emoi.mp3",
  saiko: "/Users/satoru/Dropbox/00_WIP/saiko.mp3"
}

def play(file)
  spawn "afplay #{file}"
end

get '/' do
  if !request.websocket?
    @tracks = tracks
    slim :index
  else
    request.websocket do |ws|
      ws.onopen do
        ws.send("WebSocket connected!")
        settings.sockets << ws
      end
      ws.onmessage do |msg|
        p msg
        EM.next_tick {
          settings.sockets.each{ |s|
            play(tracks[msg.to_sym]) if tracks.include? msg.to_sym
          }
        }
      end
      ws.onclose do
        warn("websocket closed")
        settings.sockets.delete(ws)
      end
    end
  end
end
