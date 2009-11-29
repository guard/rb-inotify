module INotify
  class Event
    attr_reader :cookie
    attr_reader :watcher_id
    attr_reader :name

    def self.consume(data)
      return nil if data.empty?
      ev = new(data)
      data.replace data[ev.size..-1]
      ev
    end

    def initialize(data)
      ptr = FFI::MemoryPointer.from_string(data)
      @native = Native::Event.new(ptr)
      @cookie = @native[:cookie]
      @name = data[@native.size, @native[:len]].gsub(/\0+$/, '')
      @watcher_id = @native[:wd]
    end

    def callback!
      watcher.callback!(self)
    end

    def size
      @native.size + @native[:len]
    end

    def watcher
      @watcher ||= Watcher.from_wd(@watcher_id)
    end

    def flags
      @flags ||= Native::Flags.from_mask(@native[:mask])
    end
  end
end
