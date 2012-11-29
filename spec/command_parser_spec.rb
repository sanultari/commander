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
    @option1 = @options.options.values[0]
    @options.add :option_name, abbr: :n
    @option2 = @options.options.values[1]


    @argv = @global_options << @command_name
    @argv += @command_options << @command_argument

    @tokenizer = SanUltari::CommandTokenizer.new @argv
  end

  it "should find command and upper options." do
    parser = SanUltari::CommandParser.new
    command, upper_tokens = parser.find_command @tokenizer, @commands
    command.should eq("hello")
    expected_upper_tokens = "-a", "-n", "--all", "-a", '-l', "-u", "root"
    upper_tokens.should eq(expected_upper_tokens)

    upper_options, remain_tokens = parser.get_work_options upper_tokens, @options

    upper_options.length.should eq(2)

    upper_options[0].should eq(@option1)
    upper_options[1].should eq(@option2)

    remain_tokens.length.should eq(3)
    expected_remain_tokens = '-l', "-u", "root"
    remain_tokens.should eq(expected_remain_tokens)
  end

end