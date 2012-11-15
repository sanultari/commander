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
end