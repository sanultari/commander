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
      command = operation.to_sym
      wrapper = clazz.get command
      @registry[command] = wrapper
    end

    def group group_name, clazz, operation = nil
    end

    def default command
      @default_command = command.to_sym
    end

    def get command
      @registry[command.to_sym]
    end

    def list

    end

    def run argv
      selected_command = nil
      options = []
      argv.each do |arg|
        # TODO options parsing?
        unless arg.start_with? '-' || @registry.include?(arg.to_sym)
          argv.shift
          selected_command = @registry[arg.to_sym]
          break
        else
          options.push argv.shift
        end
      end

      args = argv
      if selected_command == nil
        args += options
        options.clear
      end

      selected_command ||= @registry[@default_command] unless @default_command == nil
      selected_command.run(args, options) if selected_command != nil
    end
  end
end
