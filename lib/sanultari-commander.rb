module SanUltari
  module Command
    def self.included target
      target.extend ClassMethods
    end

    module ClassMethods
      @registry = {}

      def map command, clazz, options = nil
        @registry ||= {}
        @registry[command.to_sym] = CommandRunner.new command, clazz, nil, options
      end

      def desc command, description
      end

      def param command, param, options = nil
        @registry[command.to_sym].add_param param, options
      end

      def option command, option, options = nil
      end

      def import clazz, operation = nil
      end

      def group group_name, clazz, operation = nil
      end

      def default command
        @default_command = command.to_sym
      end

      def run argv
        selected_command = nil
        argv.each do |arg|
          unless arg.start_with? '-'
            selected_command = @registry[arg.to_sym] 
            break
          end
        end

        selected_command ||= @registry[@default_command] unless @default_command == nil
        selected_command.run(argv) if selected_command != nil
      end
    end
  end

  class CommandRunner
    attr_reader :clazz, :params, :options

    def initialize name, clazz, params = nil, options = nil
      @clazz = clazz
      @params = []
      @name = name
      @freeze = false
      @required_param_count = 0
    end

    def add_param param_name, options
      param = CommandParameter.new(param_name, options)
      if param.require? && !param.default
        @required_param_count += 1
      end
      @params.push param
    end

    def clazz= value
      @clazz = value if !@freeze 
    end

    def params= value
      @clazz = value if !@freeze
    end

    def clazz= value
      @clazz = value if !@freeze
    end

    def clazz clazz
      @clazz = clazz
    end

    def freeze?
      @freeze
    end

    def freeze!
      @freeze = true
    end

    def run args = nil
      args ||= []
      trim_index = args.index(@name.to_s)
      trim_index ||= -1
      trim_index += 1
      args = args[trim_index..-1]
      unless args.length >= @required_param_count
        # TODO: standard output change
        puts "this command has #{@required_param_count} parameters at least"
        return
      end

      runner = @clazz.new

      @params.each do |param_config|
        value = args.shift

        value ||= param_config.default

        if param_config.require? && !value
          puts "required parameter(#{param_config.name}) is missing"
          return
        end
        
        # set params
        runner.public_send "#{param_config.name}=".to_sym, value
      end
      runner.public_send @name
    end
  end

  class CommandParameter
    attr_reader :name, :default, :type

    def initialize name, options = nil
      if options
        @require = options[:require]
        @require ||= false
        @default = options[:default]
        @type = options[:type]
        @type ||= :accessor
      end
      @name = name
    end

    def require?
      @require
    end
  end
end
