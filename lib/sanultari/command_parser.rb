class SanUltari::CommandParser


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
    find_options = {}
    remain_options = []
    option_candidates.each do |item|
      if item.start_with? '-'
        if item.start_with? '--'
          name = item[2..-1]
          if options.name_include? name
            option = options.options[name.to_sym]
            find_options[option.name.to_sym] = option unless find_options.include? option.name.to_sym
            next
          end
        else
          abbr = item[1..-1]
          if options.abbr_include? abbr
            option = options.abbrs[abbr.to_sym]
            find_options[option.name.to_sym] = option unless find_options.include? option.name.to_sym
            next
          end
        end
      end
      remain_options.push item
    end
    return find_options.values, remain_options
  end

end