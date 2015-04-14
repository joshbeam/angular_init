require_relative '../lib/ngi'
require 'minitest/autorun'
require 'fakefs/spec_helpers'

describe Ngi do

  before do
    def stdin(*args)
      begin
        $stdin = StringIO.new
        $stdin.puts(args.shift) until args.empty?
        $stdin.rewind
        yield
      ensure
        $stdin = STDIN
      end
    end
  end

end