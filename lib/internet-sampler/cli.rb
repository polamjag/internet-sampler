require 'optparse'

require 'internet-sampler/application'

module InternetSampler
  class CLI
    def initialize args
      sinatra_options = {
        port: 9292,
        bind: 'localhost',
        environment: :development,
      }
      sampler_options = {
        tracks: []
      }

      opt = OptionParser.new

      opt.on('-p port', '--port port', 'port to listen (default is 9292)') { |i| sinatra_options[:port] = i.to_i }
      opt.on('-b host', '--bind host', 'host to bind (default is localhost)') { |i| sinatra_options[:bind] = i }
      opt.on('-e env', '--environment env', 'environment to run (production, test or development; default is development)') { |i|
        if %w{development test production}.include? i
          sinatra_options[:environment] = i.to_sym
        end
      }
      opt.on('-t slug:url', '--track slug:url', 'sample sound to serve (note that `url\' is not path to file but URL to serve)') { |i|
        if track = i.match(/^([^:]*):(.*)$/)
          sampler_options[:tracks] << {
            slug: track[1],
            path: track[2]
          }
        end
      }

      opt.parse! args

      InternetSampler::Application.run_with_sampler_options! sampler_options, sinatra_options
    end
  end
end
