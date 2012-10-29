class SanUltari::CommandParameter
  attr_reader :name, :default, :type

  def initialize name, options = nil
    if options
      @require = options[:require]
      @require ||= false
      @default = options[:default]
      @type = options[:type]
      @type ||= :accessor
    end
    @name = name
  end

  def require?
    @require
  end
end
