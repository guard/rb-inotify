require 'rb-inotify'
require 'tempfile'
require 'timeout'
require 'countdownlatch'

describe INotify::Notifier do
  let(:tmpfile) { Tempfile.new('some_file_for_rb-inotify_testing') }
  let(:notifier) { INotify::Notifier.new }

  after(:each) do
    File.unlink tmpfile.path
  end

  it 'should execute a callback when the specified file is modified' do
    watch_file = tmpfile
    watch_file_modified = false
    notifier.watch(watch_file.path, :modify) { watch_file_modified = true}
    t1 = Thread.new { notifier.process }
    watch_file.puts "hello world!"
    watch_file.flush
    # Wait until the thread is dead to expect the callback to have been called
    Timeout::timeout(1) { until t1.alive? === false do; sleep(0.1); end }
    expect(watch_file_modified).to eq(true)
  end

  it 'should stop when the stop method is called' do
    latch = CountDownLatch.new 1
    notifier.watch(File.dirname(tmpfile.path), :modify) {sleep(0.1)}
    t1 = Thread.new do
      notifier.run
      latch.countdown!
    end
    # wait until run has been called and initialized the stop variable
    until notifier.instance_eval { @stop } === false do; sleep(0.1); end
    notifier.stop
    latch.wait(INotify::Notifier::SELECT_TIMEOUT + 1)
    expect(t1.alive?).to eq(false)
  end
end
