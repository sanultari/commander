require "rspec"

describe "Command Parse Work" do

  before(:all) do
    @commands = {}
    @commands[:hello] = 'hello'

    @options = SanUltari::OptionDic.new
    @options.add :option_name, abbr: :n
    @options.add :all, abbr: :a

    @argv = "-a", "-b", "--all", "-al", "-u", "root", "hello","-a", "-b", "--all", "-al", "-u", "root"
    @tokenizer = SanUltari::CommandTokenizer.new @argv
  end

  it "should find command" do
    parser = SanUltari::CommandParser.new
    command, upper_option = parser.find_command @tokenizer, @commands

    command.should eq("hello")
    expected_option = "-a", "-b", "--all", "-a", "-l", "-u", "root"
    upper_option.should eq(expected_option)


  end
end