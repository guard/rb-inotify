require 'thread'

module INotify
  class Watch
    @@watches = {}
    @@mutex = Mutex.new

    attr_reader :notifier

    def self.from_wd(wd)
      @@mutex.synchronize {@@watches[wd]}
    end

    def initialize(notifier, path, *flags)
      @notifier = notifier
      @wd = Native.inotify_add_watch(@notifier.fd, path,
        Native::Flags.to_mask(flags))

      unless @wd < 0
        @@mutex.synchronize {@@watches[@wd] = self}
        return
      end

      raise SystemCallError.new(
        "Failed to watch #{path.inspect}" +
        case FFI.errno
        when Errno::EACCES::Errno; ": read access to the given file is not permitted."
        when Errno::EBADF::Errno; ": the given file descriptor is not valid."
        when Errno::EFAULT::Errno; ": path points outside of the process's accessible address space."
        when Errno::EINVAL::Errno; ": the given event mask contains no legal events; or fd is not an inotify file descriptor."
        when Errno::ENOMEM::Errno; ": insufficient kernel memory was available."
        when Errno::ENOSPC::Errno; ": The user limit on the total number of inotify watches was reached or the kernel failed to allocate a needed resource."
        else; ""
        end,
        FFI.errno)
    end

    def close
      Native.inotify_rm_watch(@notifier.fd, @wd)
    end
  end
end
