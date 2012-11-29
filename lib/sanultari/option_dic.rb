require 'sanultari/option'

class SanUltari::OptionDic
  attr_reader :options, :abbrs


  def initialize
    @options = {}
    @abbrs = {}
  end

  def add name, options = nil
    if @options.include? name
      puts "Option name duplicate. option name = #{name}."
    else
      option = SanUltari::Option.new name, options
      @options[option.name.to_sym] = option
      add_abbr option
    end
  end

  def name_include? name
    @options.include? name.to_sym
  end

  def abbr_include? abbr
    @abbrs.include? abbr.to_sym
  end

  def merge another_option_dic
    abbr_merge another_option_dic
    name_merge another_option_dic
  end


  private

  def add_abbr option
    if option.abbr == nil
      return
    end

    if abbr_include? option.abbr
      puts "Option abbr duplicate. abbr value = #{option.abbr}."
    else
      @abbrs[option.abbr.to_sym] = option
    end
  end

  def name_merge another_option_dic
    another_option_dic.options.each_pair do |name, option|
      if @options.include? name
        puts "option merge.. Option name duplicate. option name = #{name}. replace option."
      end
      @options[name] = option
    end
  end

  def abbr_merge another_option_dic
    another_option_dic.abbrs.each_pair do |abbr, option|
      if @abbrs.include? abbr
        puts "option merge.. Option abbr duplicate. abbr = #{abbr}. replace option."
        replace_option = @abbrs[abbr]
        @options.delete replace_option.name
      end
      @abbrs[abbr] = option
    end
  end

end