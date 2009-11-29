require 'ffi'

require 'ffi-inotify/native/flags'

module INotify
  module Native
    extend FFI::Library

    class Event < FFI::Struct
      layout(
        :wd, :int,
        :mask, :uint32,
        :cookie, :uint32,
        :len, :uint32,
        :name, :char)
    end

    attach_function :inotify_init, [], :int
    attach_function :inotify_add_watch, [:int, :string, :int], :int
    attach_function :inotify_rm_watch, [:int, :int], :int
  end
end
