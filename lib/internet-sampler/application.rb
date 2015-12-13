# -*- coding: utf-8 -*-

require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra-websocket'

require 'json'

require 'redis'

require 'slim'

require 'internet-sampler/sampler'
require 'internet-sampler/subscriber'
require 'internet-sampler/service'
require 'internet-sampler/version'

module InternetSampler
  class Application < Sinatra::Base
    @@sampler_options = {}

    set :root, File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'app'))
    set :server, 'thin'
    set :ws_url, ENV["WS_URL"]
    set :is, Service.new(
      Subscriber.new,
      Sampler.new(
        Redis.new(host: "127.0.0.1", port:"6379")
      )
    )

    get '/' do
      unless request.websocket?
        @ws_url = (settings.ws_url || "ws://#{request.env['HTTP_HOST']}/")
        @tracks = settings.is.sampler.tracks
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
            m = JSON.parse msg
            settings.is.play m['slug'], m['msec']
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
      settings.is.sampler.tracks.to_json
    end

    get '/api/v1/tracks/:slug/play' do
      content_type 'application/json'
      settings.is.play params[:slug]
      settings.is.track_info(params[:slug]).to_json
    end

    def self.run_with_sampler_options! sampler_options, sinatra_options
      @@sampler_options = sampler_options
      run! sinatra_options do
        @@sampler_options[:tracks].each do |track|
          settings.is.sampler.add_track track
        end
      end
    end
  end
end
