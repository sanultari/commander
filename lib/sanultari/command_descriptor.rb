require 'sanultari/command_wrapper'
require 'sanultari/option_parse'
require 'sanultari/option'


module SanUltari::CommandDescriptor
  def self.included target
    target.extend ClassMethods
  end

  module ClassMethods
    @registry = {}
    @global_option_parse = nil

    def map command, clazz, options = nil
      @registry ||= {}
      @registry[command.to_sym] = SanUltari::CommandWrapper.new command, clazz, nil, options
    end

    def desc command, description
    end

    def param command, param, options = nil
      @registry[command.to_sym].add_param param, options
    end

    def option command, option, options = nil

      if command == :global
        @global_option_parse = SanUltari::OptionParse.new if @global_option_parse == nil
        @global_option_parse.add_option option, options
        return
      end

      selected_command = @registry[command.to_sym]

      if selected_command != nil
        selected_command.option_parse.add_option option, options
      end

    end

    def import clazz, operation = nil
      targets = operation
      targets ||= clazz.available_commands
      unless targets.kind_of? Array
        targets = [targets]
      end

      if @global_option_parse == nil
        @global_option_parse = clazz.available_global_option_parse
      else
        @global_option_parse.import clazz.available_global_option_parse
      end



      targets.each do |cmd|
        command = cmd.to_sym
        wrapper = clazz.get command
        @registry[command] = wrapper
      end
    end

    def group group_name, clazz, operation = nil
    end

    def default command
      @default_command = command.to_sym
    end

    def get command
      @registry[command.to_sym]
    end

    def available_commands
      @registry.keys
    end

    def available_global_option_parse
      @global_option_parse
    end


    def list

    end

    def run argv
      selected_command = nil
      options = []
      args = []
      argument_list = argv.clone
      argv.each do |arg|
        if arg.start_with? '-'
          value = argument_list.shift

          if arg.start_with? '--'
            value = value.delete '-'
            options.push value
          else
            value = value.delete '-'
            value.each_char do |item|
              options.push item
            end
          end
          next
        end

        unless @registry.include? arg.to_sym
          args.push argument_list.shift
          next
        end

        selected_command = @registry[argument_list.shift.to_sym]
      end

      selected_command ||= @registry[@default_command] unless @default_command == nil
      selected_command.run(args, options)
    end
  end
end
