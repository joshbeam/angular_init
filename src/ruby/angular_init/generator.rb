# angular_init (short-name: ngi)
# Copyright 2015 Joshua Beam
# github.com/joshbeam/angular_init
# MIT License

class Generator
	VERSION = '0.1.0'
	WHITESPACE = /\s*/
	EMPTY = ''
	# REVIEW: Do I need this since it's defined in angular_init.rb?
	CURRENT_DIR = File.dirname(__FILE__)
	UP = '/..'

	################################

	# SET UP ALL THE CONFIG OPTIONS
	# Generator.new (the initialization function) is called in self.run

	def initialize(args)
		@type = args[:type]

		# passed in from Manager.run()
		# @CONFIG is a parsed Ruby hash from the angular_init.config.json file
		@CONFIG = args[:config]['global']

		# types that are valid (e.g. controller, directive, etc.)
		@TYPES = @CONFIG['types']

		def valid_type?
			@TYPES.select{ |t| t['name'] == @type }.size > 0
		end

		# exit if it's not a valid type (e.g. controller, directive, etc.)
		unless valid_type?
			raise @type+' is not a valid type! Select from: '+@TYPES.collect{|t| t['name'] }.to_s
		end

		template_dir = CURRENT_DIR+UP+UP+'/templates/'+@CONFIG['language']

		@TEMPLATE = template_dir + '/' + @TYPES.select{ |t| t['name'] == @type }[0]['template']

		@template_file = IO.read(@TEMPLATE)
	end

	###############################

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
		# REVIEW: use symbols instead of strings?
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
		# FIXME: don't use index accessors (numbers are confusing)
		@dependencies << auto_injections[1][:service] if @type == 'controller' && !@dependencies.include?(auto_injections[1][:service])

		# automatically insert $routeProvider into a routes config
		@dependencies << auto_injections[0][:service] if @type == 'routes' && !@dependencies.include?(auto_injections[0][:service])
	end

	def replace
		has_dependencies = @dependencies.size > 0

		# REVIEW: Use symbols instead of strings... Memory issue.
		# REVIEW: Do I need to perform this check?
		#if @TYPES.include?(@type)

			# Use 'config' as the type, since 'routes' is really an alias for a specific type of 'config'.
			@type = 'config' if @type == 'routes'

			# Regex replacements to generate the template
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
		#end
	end

	def tag
		# If Liquid-style tags are used in a template that can be used
		# for multiple components, remove those parts that don't
		# belong to the type of component user wants to generate
		@template_file =	@template_file
							.gsub(/\{\%\sif\s#{@type}\s\%\}(.*)\{\%\sendif\s#{@type}\s\%\}/m, '\1')
							.gsub(/\s\{\%\sif\s.*\s\%\}.*\{\%\sendif\s.*\s\%\}/m, '')
	end

	def write
		# create the new file
		def overwrite?
			while true
				print "File exists already, overwrite it? (y/n) "
				answer = $stdin.gets.strip

				case answer
					when 'y' #j for Germans (Ja)
						break
					when /\A[nN]o?\Z/ #n or no
						puts 'Exited!'
						exit
				end

			end

		end

		if(File.exist?(@new_file))
			overwrite?
		end

		File.open(@new_file,'w') do |file|
			file.write(@template_file)
			file.close
		end
	end

	# Use this function to be able to say ______ inside the executable file.
	def self.run(args)
		init = Generator.new(args)

		init.new_file_name

		# we don't need to define the module if we're creating a module
		init.module_name unless args[:type] == 'module'

		# 'run', 'config', and 'routes' don't have custom names in AngularJS
		# REVIEW: use symbols instead of strings?
		init.name unless ['run','config','routes'].any? { |t| t == args[:type] }

		init.inject

		init.replace

		init.tag

		init.write

		init.inspect

		puts 'All done!'
	end
end