# coding: utf-8

require "rspec"
require "spec_helper"

describe "Parameter Initialize" do

  context "Success Initialize" do
    it "option is nil" do
      param = SanUltari::CommandParameter.new(:name)

      param.name.should eq(:name)
      param.default.should eq(nil)
      param.type.should eq(nil)
      param.require?.should eq(nil)
      param.order.should eq(nil)
    end

    it "Result parameter object type data is :accessor" do
      param = SanUltari::CommandParameter.new(:name, default: "world")
      param.type.should eq(:accessor)
    end

    it "Require Value is False" do
      param = SanUltari::CommandParameter.new(:name, default: "world", require: false)
      param.require?.should eq(false)
    end

    it "Require Value is True" do
      param = SanUltari::CommandParameter.new(:name, default: "world", require: true)
      param.require?.should eq(true)
    end

    it "Skip Require value. Default Require Value is True" do
      param = SanUltari::CommandParameter.new(:name, default: "world")
      param.require?.should eq(true)
    end

  end

end