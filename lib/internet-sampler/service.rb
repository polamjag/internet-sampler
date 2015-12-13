module InternetSampler
  class Service
    attr_reader :sampler

    def initialize(subscribers, sampler)
      @sub = subscribers
      @sampler = sampler
    end

    def play slug, msec
      if @sampler.has_track? slug
        i = @sampler.incr slug
        EM.next_tick do
          @sub.broadcast({
            type: :play,
            count: i,
            slug: slug,
            msec: msec
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
end
