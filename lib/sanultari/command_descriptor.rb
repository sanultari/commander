require 'sanultari/command_wrapper'
require 'sanultari/command_parser'
require 'sanultari/option_dic'
require 'sanultari/option'


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
        selected_command.options.add name, options
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
      tokenizer = SanUltari::CommandTokenizer.new argv
      parser = SanUltari::CommandParser.new
      select_command, global_options = parser.find_command tokenizer, @registry
      remain_args = tokenizer.remain_tokens
      select_command ||= @registry[@default_command] unless @default_command == nil
      select_command.run(remain_args, global_options)
    end

  end
end
