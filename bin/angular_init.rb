class AngularInit
	VERSION = 0.1.0
	WHITESPACE = /\s*/
	EMPTY = ''
	CURRENT_DIR = File.dirname(__FILE__)
	TEMPLATE_DIRECTORY = CURRENT_DIR+'/templates'
	BASIC_TEMPLATE = TEMPLATE_DIRECTORY+'/basic.js'
	CONFIG_TEMPLATE = TEMPLATE_DIRECTORY+'/config.js'
	TYPES = [
		{
			:name => 'directive',
			:file => BASIC_TEMPLATE
		},
		{
			:name => 'controller',
			:file => BASIC_TEMPLATE
		},
		{
			:name => 'filter',
			:file => BASIC_TEMPLATE
		},
		{
			:name => 'factory',
			:file => BASIC_TEMPLATE
		},
		{
			:name => 'service',
			:file => BASIC_TEMPLATE
		},
		{
			:name => 'module',
			:file => TEMPLATE_DIRECTORY+'/module.js'
		},
		{
			:name => 'constant',
			:file => TEMPLATE_DIRECTORY+'/constant.js'
		},
		{
			:name => 'routes',
			:file => CONFIG_TEMPLATE
		},
		{
			:name => 'run',
			:file => CONFIG_TEMPLATE
		},
		{
			:name => 'config',
			:file => CONFIG_TEMPLATE
		}
	]

	def initialize(type)
		@type = type
	end

	def set_template_file
		@template_file = IO.read(TYPES.select{ |obj| obj[:name] == @type }[0][:file])
	end

	def new_file_name
		print 'New file name: '
		@new_file = $stdin.gets.gsub(WHITESPACE,EMPTY)
	end

	def module_name
		print 'Module name: '

		@module_name = $stdin.gets.gsub(WHITESPACE,EMPTY)
	end

	def name
		print @type.capitalize+' name: '

		@name = $stdin.gets.gsub(WHITESPACE,EMPTY)
	end

	def inject
		special = ['routes','controller'].include?(@type)
		auto_injections = [
			{
				:for_type => 'routes',
				:service => '$routeProvider'
			},
			{
				:for_type => 'controller',
				:service => '$scope'
			}
		]

		injection = special ? auto_injections.select { |inj| inj[:for_type] == @type }[0][:service] : nil

		auto_injection_statement = special ? " (already injected #{injection})" : ''

		print "Inject#{auto_injection_statement}: "

		# accepts a comma-delimited list
		# EXAMPLE: testService, testService2
		# => [testService,testService2]
		@dependencies = $stdin.gets.split(',').map { |dep| dep.strip }.reject(&:empty?)

		# automatically inject $scope into a controller
		# FIXME: don't use index accessors
		@dependencies << auto_injections[1][:service] if @type == 'controller' && !@dependencies.include?(auto_injections[1][:service])

		# automatically insert $routeProvider into a routes config
		@dependencies << auto_injections[0][:service] if @type == 'routes' && !@dependencies.include?(auto_injections[0][:service])
	end

	def replace
		has_dependencies = @dependencies.size > 0

		if ['directive','controller','factory','service','filter','module','constant','routes','run','config'].any? { |t| t == @type }
			@type = 'config' if @type == 'routes'

			@template_file = 	@template_file
								.gsub(/\{\{type\}\}/,@type)
								.gsub(/\{\{name\}\}/,@name || EMPTY)
								.gsub(/\{\{module\}\}/, "angular.module('#@module_name')")
								.gsub(
									/\{\{inject\s\|\sarray_string\}\}/,
									has_dependencies ?
									@dependencies.to_s.gsub(/"/,'\'')
									: '[]'
								)
								.gsub(
									/\{\{inject\s\|\scomma_delimited_variables\}\}/,
									has_dependencies ? 
									@dependencies.each_with_index.inject(EMPTY) { |str,(dep,i)| str+=dep.to_s+(i == @dependencies.size-1 ? EMPTY : ', ') }
									: EMPTY
								)
		end
	end

	def tag
		@template_file =	@template_file
							.gsub(/\{\%\sif\s#{@type}\s\%\}(.*)\{\%\sendif\s#{@type}\s\%\}/m, '\1')
							.gsub(/\s\{\%\sif\s.*\s\%\}.*\{\%\sendif\s.*\s\%\}/m, '')
	end

	def write
		File.open(@new_file,'w') do |file|
			file.write(@template_file)
			file.close
		end
	end

	def self.run(type)
		init = AngularInit.new(type)

		init.set_template_file

		init.new_file_name

		init.module_name unless type == 'module'

		init.name unless ['run','config','routes'].any? { |t| t == type }

		init.inject

		init.replace

		init.tag

		init.write

		init.inspect

		puts 'All done!'
	end
end