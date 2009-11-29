module INotify
  module Native
    module Flags
      # File was accessed.
      IN_ACCESS = 0x00000001
      # Metadata changed.
      IN_ATTRIB = 0x00000004
      # Writtable file was closed.
      IN_CLOSE_WRITE = 0x00000008
      # File was modified.
      IN_MODIFY = 0x00000002
      # Unwrittable file closed.
      IN_CLOSE_NOWRITE = 0x00000010
      # File was opened.
      IN_OPEN = 0x00000020
      # File was moved from X.
      IN_MOVED_FROM = 0x00000040
      # File was moved to Y.
      IN_MOVED_TO = 0x00000080
      # Subfile was created.
      IN_CREATE = 0x00000100
      # Subfile was deleted.
      IN_DELETE = 0x00000200
      # Self was deleted.
      IN_DELETE_SELF = 0x00000400
      # Self was moved.
      IN_MOVE_SELF = 0x00000800

      ## Helper events.

      # Close.
      IN_CLOSE = (IN_CLOSE_WRITE | IN_CLOSE_NOWRITE)
      # Moves.
      IN_MOVE = (IN_MOVED_FROM | IN_MOVED_TO)
      # All events which a program can wait on.
      IN_ALL_EVENTS = (IN_ACCESS | IN_MODIFY | IN_ATTRIB | IN_CLOSE_WRITE |
        IN_CLOSE_NOWRITE | IN_OPEN | IN_MOVED_FROM | IN_MOVED_TO | IN_CREATE |
        IN_DELETE | IN_DELETE_SELF | IN_MOVE_SELF)


      ## Special flags.

      # Only watch the path if it is a directory.
      IN_ONLYDIR = 0x01000000
      # Do not follow a sym link.
      IN_DONT_FOLLOW = 0x02000000
      # Add to the mask of an already existing watch.
      IN_MASK_ADD = 0x20000000
      # Only send event once.
      IN_ONESHOT = 0x80000000


      ## Events sent by the kernel.

      # Backing fs was unmounted.
      IN_UNMOUNT = 0x00002000
      # Event queued overflowed.
      IN_Q_OVERFLOW = 0x00004000
      # File was ignored.
      IN_IGNORED = 0x00008000
      # Event occurred against dir.
      IN_ISDIR = 0x40000000

      def self.to_mask(flags)
        flags.map {|flag| const_get("IN_#{flag.to_s.upcase}")}.
          inject(0) {|mask, flag| mask | flag}
      end

      def self.from_mask(mask)
        constants.select do |c|
          next false unless c =~ /^IN_/
          const_get(c) & mask != 0
        end.map {|c| c.sub("IN_", "").downcase.to_sym} - [:all_events]
      end
    end
  end
end
