require 'internet-sampler/cli'

module InternetSampler
  class << self
    def run! args
      CLI.new args
    end
  end
end
