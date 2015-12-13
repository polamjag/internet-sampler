class Time
  def msec
    self.instance_eval { self.to_i * 1000 + (usec/1000) }
  end
end
