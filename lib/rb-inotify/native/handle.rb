module INotify
  module Native
    # Wrapper around the underlying file handle, to keep track of whether it's
    # been closed, and ensure it's not leaked if the Notifier goes out of scope
    # without an explicit #close.
    #
    # @private
    class Handle
      def initialize(fd)
        @fd = fd
      end

      # The underlying file descriptor for this notifier.
      #
      # @return [Fixnum]
      def fileno
        @fd
      end

      # @return [Proc] A Proc that will close this handle when called;
      # suitable for use as an object finalizer.
      def finalizer
        proc { close }
      end

      # Same as IO#readpartial, or as close as we need.
      def readpartial(size)
        tries = 0
        begin
          tries += 1
          buffer = FFI::MemoryPointer.new(:char, size)
          size_read = Native.read(@fd, buffer, size)
          return buffer.read_string(size_read) if size_read >= 0
        end while FFI.errno == Errno::EINTR::Errno && tries <= 5

        raise SystemCallError.new("Error reading inotify events" +
          case FFI.errno
          when Errno::EAGAIN::Errno; ": no data available for non-blocking I/O"
          when Errno::EBADF::Errno; ": invalid or closed file descriptor"
          when Errno::EFAULT::Errno; ": invalid buffer"
          when Errno::EINVAL::Errno; ": invalid file descriptor"
          when Errno::EIO::Errno; ": I/O error"
          when Errno::EISDIR::Errno; ": file descriptor is a directory"
          else; ""
          end,
          FFI.errno)
      end

      # Close the underlying native fd.
      def close
        return if @fd.nil?

        if Native.close(@fd) == 0
          @fd = nil
          return
        end

        raise SystemCallError.new("Failed to properly close inotify socket" +
         case FFI.errno
         when Errno::EBADF::Errno; ": invalid or closed file descriptior"
         when Errno::EIO::Errno; ": an I/O error occured"
         end,
         FFI.errno)
      end
    end
  end
end
