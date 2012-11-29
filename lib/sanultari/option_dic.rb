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

end