require 'sanultari/command_wrapper'
require 'sanultari/command_parser'
require 'sanultari/option_dic'


module SanUltari::CommandDescriptor
  def self.included target
    target.extend ClassMethods
  end

  module ClassMethods
    @registry = {}
    @global_options = nil

    def map command, clazz, options = nil
      @registry ||= {}
      @registry[command.to_sym] = SanUltari::CommandWrapper.new command, clazz, nil, options
    end

    def desc command, description
    end

    def param command, param, options = nil
      @registry[command.to_sym].add_param param, options
    end

    def option command, name, options = nil
      selected_command = @registry[command.to_sym]
      if selected_command != nil
        selected_command.work_options.add name, options
      end

    end

    def global_option name, options = nil
      @global_options = SanUltari::OptionDic.new if @global_options == nil
      @global_options.add name, options
    end

    def import clazz, operation = nil
      targets = operation
      targets ||= clazz.available_commands
      unless targets.kind_of? Array
        targets = [targets]
      end

      if @global_options == nil
        @global_options = clazz.available_global_options
      else
        @global_options.merge clazz.available_global_options
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

    def available_global_options
      @global_options
    end

    def list

    end

    def run argv
      tokenizer = SanUltari::CommandTokenizer.new argv
      parser = SanUltari::CommandParser.new
      select_command, global_option_candidates = parser.find_command tokenizer, @registry
      global_options, remain_tokens = parser.get_work_options global_option_candidates, @global_options

      remain_args = remain_tokens + tokenizer.remain_tokens
      select_command ||= @registry[@default_command] unless @default_command == nil
      select_command.run(remain_args, global_options)
    end
  end
end
