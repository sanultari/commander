class SanUltari::CommandParameter
  attr_reader :name, :default, :type, :order

  def initialize name, options = nil
    if options
      @default = options[:default]
      @type = options[:type]
      @type ||= :accessor
      @require = options[:require]
      @require ||= true
      if @type == :parameter
        @order = options[:order]
        @order ||= -1
      end
    end
    @name = name
  end

  def require?
    @require
  end
end
