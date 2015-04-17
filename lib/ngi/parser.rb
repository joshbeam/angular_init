
require_relative 'utils/utils'
require_relative 'delegate'
require_relative 'version'

# This class is just a wrapper for the main process
# of ngi. It looks at the user input and passes
# arguments to either Configure or Generator.
# It also handles retrieving the configuration files
# from lib/config/config.yml so that they only have
# to be read in *one place*.
class Parser
  CURRENT_DIR = File.dirname(__FILE__)

  COMPONENTS_FILE = "#{CURRENT_DIR}/../config/config.components.yml"
  COMPONENTS_HASH = Delegate::Configure
                    .new(COMPONENTS_FILE)
                    .to_ruby(from: 'yaml')
  COMPONENTS = COMPONENTS_HASH.collect { |c| c['name'] }

  CONFIG_FILE = "#{CURRENT_DIR}/../config/config.yml"
  CONFIG_HASH = Delegate::Configure.new(CONFIG_FILE).to_ruby(from: 'yaml')

  CONFIGURABLE_FILE = "#{CURRENT_DIR}/../config/config.configurable.yml"
  CONFIGURABLE = Delegate::Configure
                 .new(CONFIGURABLE_FILE).to_ruby(from: 'yaml')

  LANGUAGES_FILE = "#{CURRENT_DIR}/../config/config.languages.yml"
  LANGUAGES_HASH = Delegate::Configure.new(LANGUAGES_FILE).to_ruby(from: 'yaml')

  # Abstraction to choose the component (custom or default).
  # If a custom component exists in config/config.yml, then
  # this class will select the attributes from that and
  # build a component to pass into Generator. If no custom
  # component exists, then the default attributes from
  # config/config.components.yml are used to build a component
  # to pass into Generator.
  class ComponentChooser
    attr_reader :component

    def initialize(args)
      chosen_type = -> (c) { c['name'] == args[:type] }
      @component = args[:components_hash].find(&chosen_type)

      return unless args[:config_hash].key? 'templates'

      custom = args[:config_hash]['templates'].find(&chosen_type)
      language = args[:config_hash]['language'].collect { |_, v| v }

      return if custom.nil?

      template = custom['templates']
                 .find { |t| language.include? t['language'] }

      return if template.nil?

      template = template['template']
      # Rebuild the object to be used by Delegate::Generator
      custom = {
        'type' => custom['type'], 'using' => 'user',
        'template' => template, 'name' => custom['name']
      }

      @component = custom
    end
  end

  # Here we implement CommandParser to use in the
  # executable file.
  def self.parse(args)
    p = Utils::CommandParser.new do |parser|
      components = Utils::UserInput.new(valid_inputs: COMPONENTS)

      parser.name, parser.version = 'ngi', Ngi::VERSION
      parser.banner << "\n(<command> can be one of the following)"

      parser.on(components.valid_inputs, 'Create a new component') do |type|
        component = ComponentChooser
                    .new(
                      type: type,
                      components_hash: COMPONENTS_HASH,
                      config_hash: CONFIG_HASH
                    )
                    .component

        Delegate::Generator.run(
          type: type,
          config: CONFIG_HASH,
          component: component
        )
      end

      parser.on(['-o', '--options'], 'Configure ngi') do
        Delegate::Configure.run(
          write: true,
          to: 'yaml',
          destination: CONFIG_FILE,
          languages: LANGUAGES_HASH,
          config: CONFIG_HASH,
          components: COMPONENTS,
          components_hash: COMPONENTS_HASH,
          configurable: CONFIGURABLE
        )
      end
    end

    p.parse(args)
  end
end
