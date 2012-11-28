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
end