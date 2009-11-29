class INotify
  class Watch
    def initialize(path, *flags)
      @wd = Native.inotify_add_watch(INotify.instance.fd, path,
        flags.map {|flag| INotify::Native::Flags.const_get("IN_#{flag.to_s.upcase}")}.
        inject(0) {|mask, flag| mask | flag})
      return unless @wd < 0

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
      Native.inotify_rm_watch(INotify.instance.fd, @wd)
    end
  end
end
