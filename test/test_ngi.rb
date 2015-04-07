require_relative '../lib/ngi'
require 'minitest/autorun'
require 'json'

describe Ngi do
  DIR = File.dirname(__FILE__)

  describe Ngi::Delegate::Configure do
    before do
      @path = "#{DIR}/sup/test.config.json"
      @config = Ngi::Delegate::Configure.new(@path)
    end

    describe 'when initialized' do
      it 'must read the file given from the path' do
        @config.file.must_equal IO.read(@path)
      end
    end
  end
end
# class TestNgi < Test::Unit::TestCase
#   CURRENT_DIR = File.dirname(__FILE__)

#   def configure_init
#     path = CURRENT_DIR + '/sup/test.config.json'
#     configure = Ngi::Delegate::Configure.new(path)

#     r = {
#       path: path,
#       configure: configure
#     }

#     r
#   end

#   def test_configure_file
#     c = configure_init

#     assert_equal(c[:configure].file, IO.read(c[:path]))
#   end

#   def test_configure_json
#     c = configure_init
#     file = c[:configure].file
#     json_file = c[:configure].from_json

#     assert_equal(json_file, JSON.parse(file))
#   end

#   def test_configure_run
#     c = configure_init
#     file = c[:configure].file
#     Ngi::Delegate::Configure.run(write: false, file_path: c[:path])

#     # assert that even if we change a property in the config file,
#     # it never gets written UNLESS in Configure#run, write == true
#     assert_equal(file, IO.read(c[:path]))
#   end
# end
