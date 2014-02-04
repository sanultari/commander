class SanUltari::Option
  attr_accessor :value
  attr_reader :name, :abbr, :type, :require

  def initialize name, options = nil
    if options
      @abbr = options[:abbr]
      @type = options[:type]
      @type ||= :boolean
      @require = options[:require]
      @require = false if options[:require] == nil

      @value = options[:value]
      @value ||= true if @type == :boolean
    end
    @name = name
  end

  def require?
    @require
  end
end