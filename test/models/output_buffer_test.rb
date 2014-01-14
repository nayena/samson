require 'test_helper'

describe OutputBuffer do
  let(:buffer) { OutputBuffer.new }

  it "allows writing chunks of data to multiple listeners" do
    listener1 = build_listener
    listener2 = build_listener

    buffer.write("hello")
    buffer.write("world")
    buffer.close

    listener1.value.must_equal ["hello", "world"]
    listener2.value.must_equal ["hello", "world"]
  end

  it "writes the previous content to new listeners" do
    buffer.write("hello")

    listener = build_listener
    buffer.close

    listener.value.must_equal ["hello"]
  end

  def build_listener
    Thread.new do
      content = []
      buffer.each {|chunk| content << chunk }
      content
    end
  end
end
