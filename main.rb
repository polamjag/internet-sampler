# -*- coding: utf-8 -*-
require 'bundler/setup'

require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra-websocket'

require 'slim'

set :server, 'thin'
set :sockets, []

tracks = {
  "エモい" => "/mp3/emoi.mp3",
  "最高" => "/mp3/saiko.mp3"
}

def get_abs_path(filename)
  File.join(File.dirname(__FILE__), '/public', filename)
end

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
        settings.sockets.each do |s|
          s.send "num:#{settings.sockets.length}"
        end
      end
      ws.onmessage do |msg|
        puts "Play: #{msg}"
        EM.next_tick do
          settings.sockets.each do |s|
            if tracks.include? msg.to_s
              # play on server
              play(get_abs_path(tracks[msg.to_s]))
              # play on clients
              s.send "play:#{msg.to_s}"
            end
          end
        end
      end
      ws.onclose do
        warn("websocket closed")
        settings.sockets.delete(ws)
        settings.sockets.each do |s|
          s.send "num:#{settings.sockets.length}"
        end
      end
    end
  end
end
