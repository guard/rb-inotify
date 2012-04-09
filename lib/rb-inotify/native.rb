require 'ffi'
require 'rb-inotify/notifier'

module INotify
  # This module contains the low-level foreign-function interface code
  # for dealing with the inotify C APIs.
  # It's an implementation detail, and not meant for users to deal with.
  #
  # @private
  module Native
    extend FFI::Library
    ffi_lib "c"

    # @private
    EventSize = 16

    attach_function :inotify_init, [], :int
    attach_function :inotify_add_watch, [:int, :string, :uint32], :int
    attach_function :inotify_rm_watch, [:int, :uint32], :int

    unless NotifierMixin.supports_ruby_io?
      attach_function :read, [:int, :pointer, :size_t], :ssize_t
      attach_function :close, [:int], :int
    end
  end
end
