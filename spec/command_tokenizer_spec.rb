require "rspec"

describe "Command Tokenizer Work" do

  before(:all) do
    #@commands = {}
    #@commands[:hello] = 'hello'
    #
    #@options = SanUltari::OptionDic.new
    #@options.add :option_name, abbr: :n
    #@options.add :all, abbr: :a

    @argv = "-a", "-b", "--all", "-al", "-u", "root", "hello","-a", "-b", "--all", "-al", "-u", "root"
    @tokenizer = SanUltari::CommandTokenizer.new @argv
  end


  it "should Get first next_token. value is -a" do
    expected_length = @tokenizer.remain_tokens.length
    token = @tokenizer.next_token
    token.should eq '-a'
    @tokenizer.remain_tokens.length.should eq(expected_length-1)
  end
end