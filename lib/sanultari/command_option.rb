class SanUltari::CommandOption
  attr_accessor :full_name, :short_name, :type, :value

  def initialize full_name, short_name = nil, type = :boolean, value = false
    @full_name = full_name
    @short_name = short_name
    @type = type
    @value = value
  end

  def short_name_exist?
    result = false
    unless @short_name.nil?
      result = true
    end
    result
  end

end