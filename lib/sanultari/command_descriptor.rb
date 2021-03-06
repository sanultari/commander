require 'sanultari/command_wrapper'

module SanUltari::CommandDescriptor
  def self.included target
    target.extend ClassMethods
  end

  module ClassMethods
    @registry = {}

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
    end

    def import clazz, operation = nil
      targets = operation
      targets ||= clazz.available_commands
      unless targets.kind_of? Array
        targets = [targets]
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
          args.push value
          options.push value
          next
        end

        unless @registry.include? arg.to_sym
          args.push argument_list.shift
          next
        end

        selected_command = @registry[argument_list.shift.to_sym]
      end

      args += argument_list
      if selected_command == nil
        options.clear
      else
        args -= options
      end

      selected_command ||= @registry[@default_command] unless @default_command == nil
      selected_command.run(args, options) if selected_command != nil
    end
  end
end
