require 'ffi'

module INotify
  # This module contains the low-level foreign-function interface code
  # for dealing with the inotify C APIs.
  # It's an implementation detail, and not meant for users to deal with.
  #
  # @private
  module Native
    extend FFI::Library

    # The C struct describing an inotify event.
    #
    # @private
    class Event < FFI::Struct
      layout(
        :wd, :int,
        :mask, :uint32,
        :cookie, :uint32,
        :len, :uint32)
    end

    attach_function :inotify_init, [], :int
    attach_function :inotify_add_watch, [:int, :string, :int], :int
    attach_function :inotify_rm_watch, [:int, :int], :int
  end
end
