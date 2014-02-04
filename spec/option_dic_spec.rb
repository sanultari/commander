require "spec_helper"

describe "OptionDic Work" do

  before(:each) do
    @option_dic = SanUltari::OptionDic.new
  end

  context "Add option work." do

    it "add option. this options is not duplicate. normal option." do
      @option_dic.add :option_name
      @option_dic.options.length.should eq(1)
    end

    it "add option. this options is not duplicate. more option value.. abbr, require" do
      @option_dic.add :option_name, abbr: :n, require: false
      @option_dic.options.length.should eq(1)
    end

    it "add option fail. option name is duplicate" do
      @option_dic = SanUltari::OptionDic.new
      @option_dic.add :option_name
      @option_dic.add :option_name
      @option_dic.options.length.should eq(1)
    end

  end

end