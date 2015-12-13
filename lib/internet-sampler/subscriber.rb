module InternetSampler
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
end
