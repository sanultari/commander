# coding: utf-8

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')


class Hello
  attr_accessor :name

  def hello
    puts "Hello, #{self.name}"
  end
end

class Goodbye
  def bye name, options = nil
    if options != nil && options.length > 0
      options.each do |option|
        puts "Goodbye #{name} options = #{option}"
      end
    else
      puts "Goodbye #{name}"
    end
  end


  def bye2
    puts "잘가라"
  end

end




class AnotherRunner
  include SanUltari::CommandDescriptor

  option_manager = SanUltari::CommandOptionManager.new

  option_manager.add_option SanUltari::CommandOption.new :all, :a
  option_manager.add_option SanUltari::CommandOption.new :l
  option_manager.add_option SanUltari::CommandOption.new :u, nil, :String, ""




  #, desc: 'goodbye command'
  map :bye, Goodbye, option_manager
  param :bye, :name, type: :parameter

  map :bye2, Goodbye
end

class Runner
  include SanUltari::CommandDescriptor

  default :hello

  map :hello, Hello, desc: 'hello command'
  desc :hello, 'hello'
  # type: :attribute is default
  param :hello, :name, require: true, default: 'World', type: :accessor
  # second parameter is optional. second parameter can remove for importing all commands
  import AnotherRunner
  # another importing method. imported commands has group. commands having same name can be distinguish
  # last optional parameter is same functionally with above method
  group :say, AnotherRunner
end

Runner.run ARGV


# ruby sample.rb -v -h --help hello --test tim
#  > Hello, tim