require 'sanultari/command_parameter'

class SanUltari::CommandWrapper
  attr_reader :clazz, :params, :options

  def initialize name, clazz, params = nil, options = nil
    @name = name
    @clazz = clazz
    @params = params
    @params ||= []
    @options = options
    @options ||= {}
    @freeze = false
    @required_param_count = 0
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

    # TODO options parsing
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
      runner.public_send "#{current_param_config.name}=".to_sym, value
      param_configs.shift
    end

    param_configs.each do |param_config|
      value = param_config.default

      if param_config.require? && !value
        puts "required parameter(#{param_config.name}) is missing"
        return
      end

      runner.public_send "#{param_config.name}=".to_sym, value
      param_configs.shift
    end

    runner.public_send @name
  end
end
