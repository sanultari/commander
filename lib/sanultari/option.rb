class SanUltari::Option
  attr_reader :name, :abbr, :type, :require, :value

  def initialize name, options = nil
    if options
      @abbr = options[:abbr]
      @type = options[:type]
      @type ||= :boolean
      @require = options[:require]
      @require = false if options[:require] == nil
    end
    @name = name
  end

  def require?
    @require
  end
end