class SanUltari::CommandTokenizer

  attr_reader :remain_tokens

  def initialize argv
    @remain_tokens = []
    argv.each do |arg|
      if arg.start_with? '-'
        register_option(arg)
      else
        @remain_tokens.push arg
      end
    end
  end

  def register_option(arg)
    if arg.start_with? '--'
      @remain_tokens.push arg
    else
      abbrs = arg[1..-1]
      abbrs.each_char do |abbr|
        @remain_tokens.push '-'+ abbr
      end
    end
  end

  def next_token
    @remain_tokens.shift
  end

end