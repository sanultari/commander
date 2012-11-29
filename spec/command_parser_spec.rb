require "rspec"

describe "Command Parse Work" do

  before(:all) do

    @global_options = "-a", "-n", "--all", "-al", "-u", "root"
    @command_options = "-a", "--all", "-al", "-u", "root"
    @command_argument = 'tim'
    @command_name = 'hello'

    @commands = {}
    @commands[:hello] = @command_name

    @options = SanUltari::OptionDic.new

    @options.add :all, abbr: :a
    @option0 = @options.options.values[0]
    @options.add :option_name, abbr: :n
    @option1 = @options.options.values[1]

    @options.add :str, abbr: :s, type: :string
    @option2 = @options.options.values[2]


    @argv = @global_options << @command_name
    @argv += @command_options << @command_argument

    @tokenizer = SanUltari::CommandTokenizer.new @argv
    @parser = SanUltari::CommandParser.new
  end

  it "should find command and upper options." do

    command, upper_tokens = @parser.find_command @tokenizer, @commands
    command.should eq("hello")
    expected_upper_tokens = "-a", "-n", "--all", "-a", '-l', "-u", "root"
    upper_tokens.should eq(expected_upper_tokens)

    upper_options, remain_tokens = @parser.get_work_options upper_tokens, @options

    upper_options.length.should eq(2)

    upper_options[0].should eq(@option0)
    upper_options[1].should eq(@option1)

    remain_tokens.length.should eq(3)
    expected_remain_tokens = '-l', "-u", "root"
    remain_tokens.should eq(expected_remain_tokens)
  end

  it "should find option. option type is string" do

    option_tokens = '-s', 'str_value', 'hello', '-q'
    options, remain_tokens = @parser.get_work_options option_tokens, @options

    options.length.should eq(1)
    options[0].should eq(@option2)
    options[0].value.should eq('str_value')

    remain_tokens.length.should eq(2)
    remain_tokens[0].should eq('hello')
    remain_tokens[1].should eq('-q')
  end


end