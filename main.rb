# -*- coding: utf-8 -*-
require 'bundler/setup'

require 'json'

require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra-websocket'

require 'redis'

require 'slim'

class Subscriber
  attr_reader :subscribers

  def initialize
    @subscribers = []
  end

  def add ws
    @subscribers << ws
  end

  def delete ws
    @subscribers.delete ws
  end

  def send ws, message
    ws.send message
  end

  def broadcast message
    @subscribers.each do |sub|
      sub.send message
    end
  end

  def count
    @subscribers.size
  end
end

class Sampler
  def initialize tracks, redis
    @tracks = tracks
    @redis = redis
  end

  def has_track? slug
    @tracks.select do |track|
      track[:slug] == slug
    end.size == 1
  end

  def get_count slug
    @redis.get slug if has_track? slug
  end

  def incr slug
    @redis.incr slug if has_track? slug
  end

  def tracks
    @tracks.map do |track|
      track[:count] = @redis.get track[:slug]
      track
    end
  end

  def track_info slug
    t = @tracks.select do |track|
      track[:slug] == slug
    end.first
    t[:count] = @redis.get slug
    t
  end
end

class InternetSampler
  def initialize subscribers, sampler
    @sub = subscribers
    @sampler = sampler
  end

  def play slug
    if @sampler.has_track? slug
      i = @sampler.incr slug
      EM.next_tick do
        @sub.broadcast({
          type: :play,
          count: i,
          slug: slug
        }.to_json)
      end
    else
      puts :err
    end
  end

  def add ws
    @sub.add ws
  end

  def delete ws
    @sub.delete ws
  end

  def update_subscribers_count
    @sub.broadcast({
      type: :num,
      count: @sub.count,
    }.to_json)
  end

  def tracks
    @sampler.tracks
  end

  def track_info slug
    @sampler.track_info slug
  end
end

configure do
  set :server, 'thin'
  set :ws_url, ENV["WS_URL"]
  set :is, InternetSampler.new(
    Subscriber.new,
    Sampler.new(
      [
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
          slug: "銅鑼",
          path: "/mp3/Gong-266566.mp3",
          description: ""
        },
        {
          slug: "Frontliner",
          path: "/mp3/frontliner-fsharp-kick.mp3",
          description: ""
        }
      ],
      Redis.new(host: "127.0.0.1", port:"6379")
    )
  )
end

get '/' do
  if !request.websocket?
    @ws_url = (settings.ws_url || "ws://#{request.env['HTTP_HOST']}/")
    @tracks = settings.is.tracks
    p @tracks
    slim :index
  else
    request.websocket do |ws|
      ws.onopen do
        settings.is.add ws
        ws.send({
          type: :msg,
          msg: "WebSocket connected!"
        }.to_json)
        settings.is.update_subscribers_count
      end

      ws.onmessage do |msg|
        puts "Play: #{msg}"
        settings.is.play msg
      end

      ws.onclose do
        warn("WebSocket closed")
        settings.is.delete ws
        settings.is.update_subscribers_count
      end
    end
  end
end

get '/api/v1/tracks' do
  content_type 'application/json'
  settings.is.tracks.to_json
end

get '/api/v1/tracks/:slug/play' do
  content_type 'application/json'
  settings.is.play params[:slug]
  settings.is.track_info(params[:slug]).to_json
end
