module InternetSampler
  class Sampler
    def initialize redis
      @tracks = []
      @redis = redis
    end

    def has_track? slug
      @tracks.select do |track|
        track[:slug] == slug
      end.size == 1
    end

    def add_track track
      @tracks << track
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
end
