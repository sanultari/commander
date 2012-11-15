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

  #, desc: 'goodbye command'
  map :bye, Goodbye
  param :bye, :name, type: :parameter

  # default require value is false
  # default type is boolean
  option :bye, :name, abbr: :n, type: :string, require: true
  # propagate all sub commands and sub modules
  option :global, :verbose, abbr: :v

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