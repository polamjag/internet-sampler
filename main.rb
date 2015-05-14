# -*- coding: utf-8 -*-
require 'bundler/setup'

require 'json'

require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra-websocket'

require 'redis'

require 'slim'

set :server, 'thin'
set :sockets, []

tracks = [
  {
    slug: "エモい",
    path: "/mp3/emoi.mp3",
    description: ""
  },
  {
    slug: "最高",
    path: "/mp3/saiko.mp3",
    description: ""
  },
  {
    slug: "Frontliner",
    path: "/mp3/frontliner-fsharp-kick.mp3",
    description: ""
  }
]

redis = Redis.new host:"127.0.0.1", port:"6379"

get '/' do
  if !request.websocket?
    @tracks = tracks.each do |track|
      track[:count] = redis.get(track[:slug])
    end
    slim :index
  else
    request.websocket do |ws|

      ws.onopen do
        ws.send({
          type: :msg,
          msg: "WebSocket connected!"
        }.to_json)
        settings.sockets << ws
        settings.sockets.each do |s|
          s.send({
            type: :num,
            count: settings.sockets.length
          }.to_json)
        end
      end

      ws.onmessage do |msg|
        if tracks.any? { |t| t[:slug] == msg.to_s }
          puts "Play: #{msg}"
          count = redis.incr(msg.to_s)
          EM.next_tick do
            settings.sockets.each do |s|
              s.send({
                type: :play,
                count: count,
                slug: msg
              }.to_json)
            end
          end
        end
      end

      ws.onclose do
        warn("WebSocket closed")
        settings.sockets.delete(ws)
        settings.sockets.each do |s|
          s.send({
            type: :num,
            count: settings.sockets.length
          }.to_json)
        end
      end

    end
  end
end
