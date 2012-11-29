require 'sanultari/option_dic'

class SanUltari::CommandParser

  def initialize
    @find_options = {}
    @incomplete_options = []
    @remain_options = []
  end

  def find_command tokenizer, commands
    command = nil
    upper_option_part = []
    while 0 < tokenizer.remain_tokens.length
      token = tokenizer.next_token
      if commands.include? token.to_sym
        command = commands[token.to_sym]
        break
      else
        upper_option_part.push token
      end
    end

    return command, upper_option_part
  end

  def get_work_options option_candidates, options

    if options == nil
      @remain_options = option_candidates
    else
      option_candidates.each do |item|
        option_parse item, options
      end
    end
    find_options = @find_options.values.clone
    remain_options = @remain_options.clone
    var_clear
    return find_options, remain_options
  end


  def get_args argv
    args = []
    argv.each do |arg|
      unless arg.start_with? '-'
        args.push arg
      end
    end
    args
  end


  def var_clear
    @find_options.clear
    @remain_options.clear
    @incomplete_options.clear
  end


  private

  def option_parse option_candidate, options = {}
    if option_candidate.start_with? '-'
      option_register_check option_candidate, options
    else
      argument_check option_candidate
    end
  end

  def option_register_check item, options
    if item.start_with? '--'
      name_check item, options
    else
      abbr_check item, options
    end
  end

  def name_check item, options
    name = item[2..-1]
    option = options.options[name.to_sym] if options.name_include? name
    find_option_after_work item, option
  end

  def abbr_check item, options
    abbr = item[1..-1]
    option = options.abbrs[abbr.to_sym] if options.abbr_include? abbr
    find_option_after_work item, option
  end

  def find_option_after_work item, option = nil
    if option != nil
      @find_options[option.name.to_sym] = option unless @find_options.include? option.name.to_sym
      @incomplete_options.push option if option.type != :boolean
    else
      @remain_options.push item
    end
  end

  def argument_check arg
    if 0 < @incomplete_options.length
      option = @incomplete_options.shift
      option.value = arg
    else
      @remain_options.push arg
    end
  end
end