module INotify
  class Event
    attr_reader :cookie
    attr_reader :name

    def self.consume(data)
      return nil if data.empty?
      ev = new(data)
      data.replace data[ev.size..-1]
      ev
    end

    def initialize(data)
      ptr = FFI::MemoryPointer.new(data)
      @native = Native::Event.new(ptr)
      @cookie = @native[:cookie]
      @name = data[@native.size, @native[:len]]
    end

    def size
      @native.size + @native[:len]
    end

    def watch
      @watch ||= Watch.from_wd(@native[:wd])
    end

    def flags
      @flags ||= Native::Flags.from_mask(@native[:mask])
    end
  end
end
