require 'singleton'

module INotify
  class Notifier < IO
    def initialize
      @fd = Native.inotify_init
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

    def watch(path, *flags)
      Watch.new(self, path, *flags)
    end
  end
end
