require 'sanultari/option'

class SanUltari::OptionParse
  attr_reader :names, :abbrs

  def initialize
    @names = {}
    @abbrs = {}

  end


  def add_option name, options = nil

    option = SanUltari::Option.new name, options

    if @names.include? name
      puts "Option name duplicate. #{name}"
      return
    end

    if options[:abbr] != nil
      if @abbrs.include? options[:abbr]
        puts "Option abbr duplicate. #{options[:abbr]}"
        return
      end
      @abbrs[options[:abbr].to_sym] = option
    end

    @names[name.to_sym] = option

  end

  def import option_parse
    option_parse.names.keys.each do |name|
      option = option_parse.get_option_by_name name
      @names[name] = option
    end

    option_parse.abbrs.keys.each do |abbr|
      option = option_parse.get_option_by_abbr abbr
      @abbrs[abbr] = option
    end
  end

  def get_option_by_name name
    @names[name.to_sym]
  end

  def get_option_by_abbr abbr
    @abbrs[abbr.to_sym]
  end

  def get_option option_list, name
    option_list[name.to_sym]
  end

  def parse options
    find_options = {}
    option_list = options.clone
    not_exist_options = []
    options.each do |item|
      value = option_list.shift
      if item.start_with? '-'
        if item.start_with? '--'
          option = value[2..-1]
          find_option :get_option_by_name, option, find_options, not_exist_options, '--'
          next
        end

        option = value[1..-1]
        option.each_char do |abbr|
          find_option :get_option_by_abbr, abbr, find_options, not_exist_options, '-'
        end
      else
        not_exist_options.push value
      end
    end

    return find_options.values, not_exist_options
  end


  def find_option name, value, find_options, not_exist_options, option_header
    find_option = self.public_send name, value
    if find_option != nil
      find_options[find_option.name.to_sym] = find_option
    else
      not_exist_options.push (option_header + value)
    end
  end
end