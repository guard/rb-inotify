module INotify
  class Notifier < IO
    attr_reader :watchers

    def initialize
      @fd = Native.inotify_init
      @watchers = {}
      return super(@fd) unless @fd < 0

      raise SystemCallError.new(
        "Failed to initialize inotify" +
        case FFI.errno
        when Errno::EMFILE::Errno; ": the user limit on the total number of inotify instances has been reached."
        when Errno::ENFILE::Errno; ": the system limit on the total number of file descriptors has been reached."
        when Errno::ENOMEM::Errno; ": insufficient kernel memory is available."
        else; ""
        end,
        FFI.errno)
    end

    attr_reader :fd

    def watch(path, *flags, &callback)
      Watcher.new(self, path, *flags, &callback)
    end

    def run
      loop {process}
    end

    def process
      read_events.each {|event| event.callback!}
    end

    def read_events
      size = 64 * Native::Event.size
      tries = 1

      begin
        data = readpartial(size)
      rescue SystemCallError => er
        # EINVAL means that there's more data to be read
        # than will fit in the buffer size
        raise er unless er.errno == EINVAL || tries == 5
        size *= 2
        tries += 1
        retry
      end

      events = []
      while ev = Event.consume(data)
        events << ev
      end
      events
    end
  end
end
