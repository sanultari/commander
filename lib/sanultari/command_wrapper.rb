require 'sanultari/command_parameter'

class SanUltari::CommandWrapper
  attr_reader :clazz, :params, :options, :option_parse

  def initialize name, clazz, params = nil, options = nil
    @name = name
    @clazz = clazz
    @params = params
    @params ||= []
    @options = options
    @options ||= {}
    @option_parse = SanUltari::OptionParse.new
    @freeze = false
    @required_param_count = 0

    # TODO : deprecate
    @args = []
  end

  def add_param param_name, options
    param = SanUltari::CommandParameter.new(param_name, options)
    if param.require? && !param.default
      @required_param_count += 1
    end
    @params.push param
  end

  def params= value
    @clazz = value if !@freeze
  end

  def clazz= value
    @clazz = value if !@freeze
  end

  def freeze?
    @freeze
  end

  def freeze!
    @freeze = true
  end

  def run args = nil, options = nil
    args ||= []
    options ||= []
    unless args.length >= @required_param_count
      # TODO: standard output change
      puts "this command has #{@required_param_count} parameters at least"
      return
    end

    runner = @clazz.new
    # TODO options parsing
    options, param_configs = set_values runner, args, options
    set_defaults runner, param_configs

    if runner.public_method(@name).parameters.length > 0
      puts "this command is misconfigured for method arguments" if runner.public_method(@name).parameters.length < @args.length

      if options.length > 0
        runner.public_send @name, *@args, options
      else
        runner.public_send @name, *@args
      end

    else

      runner.public_send @name

    end
  end

  def run2 argv = nil, global_options = nil
    argv ||= []
    global_options ||= []
    args, option_names = parse_argv argv

    options = self.option_parse.get_options



  end

  def parse_argv argv
    args = []
    option_names = []
    argument_list = argv.clone
    argv.each do |arg|
      if arg.start_with? '-'
        value = argument_list.shift
        option_names.push value
        next
      end

      args.push argument_list.shift
    end
    return args, option_names
  end


  private
  def set_value object, name, value
    object.public_send "#{name}=".to_sym, value
  end

  def handle_args param_config, value
    if param_config.order < 0
      @args.push value
    else
      if @args[order] == nil
        @args[order] = value
      else
        puts "this command is mis-configured. some arguments have same order."
      end
    end
  end

  def set_defaults object, param_configs
    param_configs.each do |param_config|
      value = param_config.default

      if param_config.require? && !value
        puts "required parameter(#{param_config.name}) is missing"
        return
      end
      set_value(object, param_config.name, value) unless value == nil
      param_configs.shift
    end
  end

  def set_values object, args, options
    param_configs = @params.clone
    args.each do |arg|
      if param_configs.empty?
        index = args.index arg
        options += args[index..-1]
        break
      end

      current_param_config = param_configs[0]
      if arg.start_with? '-'
        options.push arg
        next
      end

      # set params
      if current_param_config.type == :parameter
        handle_args current_param_config, arg
      else
        unless object.respond_to? "#{current_param_config.name}=".to_sym
          next
        end
        set_value object, current_param_config.name, arg
      end
      param_configs.shift
    end

    return options, param_configs
  end

  private :set_defaults, :set_value, :set_values
end
