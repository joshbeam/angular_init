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

    describe '#from_json' do
      it 'must convert the file to a Ruby hash' do
        file_parsed_from_json_to_ruby = @config.from_json
        regular_file = IO.read(@path)

        file_parsed_from_json_to_ruby.must_equal JSON.parse(regular_file)
      end
    end

    # describe '#self.run' do
    #   it 'must create an instance of Configure' do

    #   end
    # end

    describe '#to_json' do
      it 'must convert the file to a prettified JSON file if file is a hash' do
        regular_file = IO.read(@path)

        # set the file to a Ruby hash version of the JSON file
        @config.file = @config.from_json

        # convert the file back to a prettified JSON representation
        # if the file was a Ruby hash
        back_to_json = @config.to_json

        back_to_json.must_equal regular_file

        # set the file to a JSON version
        @config.file = regular_file
        attempt_to_generate_json = @config.to_json

        attempt_to_generate_json.must_equal regular_file
      end
    end

    describe '::Questioner' do
      before do
        c = Ngi::Delegate::Configure
        @ruby_hashed_config_file = @config.from_json
        @configurable_properties = @ruby_hashed_config_file['global']['configurable'].collect { |k,v| v }
        @questioner = c::Questioner.new(@ruby_hashed_config_file)
      end

      describe '#initialize' do
        it 'must set its file in JSON format' do
          @questioner.file.must_equal @config.from_json
        end

        it 'must collect all the configurable properties in an array' do
          @questioner.configurable_properties.must_equal @configurable_properties
        end
      end
    end
  end
end
