# angular_init (short-name: ngi)
# Copyright 2015 Joshua Beam
# github.com/joshbeam/angular_init
# MIT License

require_relative 'utils/utils'

# This class generates templates (hence the name "Generator")
class Generator
  Utils = ::Utils

  # STDIN is separated into a class so that
  # it can be extracted and tested
  class AcceptInput
    def self.str(type)
      case type
      when :condensed
        $stdin.gets.gsub(WHITESPACE, EMPTY)
      when :comma_delimited_to_array
        $stdin.gets.split(',').map(&:strip).reject(&:empty?)
      when :downcased
        $stdin.gets.strip.downcase
      end
    end
  end

  # Here we just implement
  # the virtual class Utils::AskLoop
  class AskLoop < Utils::AskLoop
    def self.ask(args)
      print "\n#{args[:prompt]}"

      answer = AcceptInput.str(:downcased)

      loop do
        break if args[:check] == answer
        puts 'Exited!'
        exit
      end

      answer
    end
  end

  WHITESPACE = /\s*/
  EMPTY = ''
  CURRENT_DIR = File.dirname(__FILE__)

  ################################

  # SET UP ALL THE CONFIG OPTIONS
  # Generator.new (the initialization function) is called in self.run

  def initialize(args)
    @type, @config = args[:type], args[:config]

    @component = args[:component]
    @component['language'] = @config['language'][@component['type']]

    template_dir = "#{CURRENT_DIR}/../templates/"
    template_dir << "#{@component['type']}/#{@component['language']}"
    template_dir << "/#{@component['using']}/#{@component['template']}"

    @template_file = IO.read(template_dir)

    yield(self) if block_given?
  end

  ###############################

  def new_file_name
    print '[?] New file name: '

    @new_file = AcceptInput.str(:condensed)
  end

  def module_name
    print '[?] Module name: '

    @module_name = AcceptInput.str(:condensed)
  end

  def name
    print "[?] #{@type.capitalize} name: "

    @name = AcceptInput.str(:condensed)
  end

  def inject
    # REVIEW: use symbols instead of strings?
    special = %w(routes controller).include?(@type)
    auto_injections = [
      { for_type: 'routes', service: '$routeProvider' },
      { for_type: 'controller', service: '$scope' }
    ]

    injection = special ? auto_injections.select { |inj| inj[:for_type] == @type }[0][:service] : nil

    auto_injection_statement = special ? " (already injected #{injection})" : ''

    print "[?] Inject#{auto_injection_statement}: "

    # accepts a comma-delimited list
    # EXAMPLE: testService, testService2
    # => [testService,testService2]
    @dependencies = AcceptInput.str(:comma_delimited_to_array)

    # automatically inject $scope into a controller
    # FIXME: don't use index accessors (numbers are confusing)
    @dependencies << auto_injections[1][:service] if @type == 'controller' && !@dependencies.include?(auto_injections[1][:service])

    # automatically insert $routeProvider into a routes config
    @dependencies << auto_injections[0][:service] if @type == 'routes' && !@dependencies.include?(auto_injections[0][:service])
  end

  def replace
    # inject may or may not have run... if it wasn't run, then @dependencies was never set
    # for example, for html templates, we don't run the inject function
    # @dependencies = @dependencies || []
    @dependencies ||= []
    has_dependencies = @dependencies.size > 0

    # Use 'config' as the type, since 'routes' is really an alias for a specific type of 'config'.
    # TODO: map aliases from config file
    @type = 'config' if @type == 'routes'

    # Regex replacements to generate the template
    @template_file =  @template_file
                      .gsub(/\{\{type\}\}/, @type)
                      .gsub(/\{\{name\}\}/, @name || '')
                      .gsub(/\{\{module\}\}/, "#{@module_name}")
                      .gsub(
                        /\{\{inject\s\|\sarray_string\}\}/,
                        has_dependencies ?
                        @dependencies.to_s.gsub(/"/, '\'') : '[]'
                      )
                      .gsub(
                        /\{\{inject\s\|\scomma_delimited_variables\}\}/,
                        has_dependencies ?
                        @dependencies.each_with_index.inject('') { |str, (dep, i)| str += dep.to_s + (i == @dependencies.size - 1 ? '' : ', ') } : ''
                      )
  end

  def tag
    # If Liquid-style tags are used in a template that can be used
    # for multiple components, remove those parts that don't
    # belong to the type of component user wants to generate
    @template_file =  @template_file
                      .gsub(/\{\%\sif\s#{@type}\s\%\}(.*)\{\%\sendif\s#{@type}\s\%\}/m, '\1')
                      .gsub(/\s\{\%\sif\s.*\s\%\}.*\{\%\sendif\s.*\s\%\}/m, '')
  end

  def write
    # create the new file
    def overwrite?
      AskLoop.ask(
        check: 'y',
        prompt: 'File exists already, overwrite it? (y/n) '
      )
    end

    overwrite? if File.exist?(@new_file)

    File.open(@new_file, 'w') do |file|
      file.write(@template_file)
      file.close
    end
  end

  # Use this function to be able to say
  # AngularInit::Delegate::Generator.run() inside
  # the executable file.
  # This function simply goes through all of the
  # methods in order to interactively
  # prompt the user to generate a new template
  def self.run(args)
    Generator.new(args) do |g|
      g.new_file_name

      # we don't need to define the module if we're creating a module
      g.module_name unless args[:type] == 'module'

      # 'run', 'config', and 'routes' don't have custom names in AngularJS
      # REVIEW: use symbols instead of strings?
      g.name unless %w(run config routes index).include? args[:type]

      g.inject unless ['index'].include? args[:type]

      g.replace

      g.tag

      g.write
    end

    puts 'All done!'
  end
end
