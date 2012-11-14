class SanUltari::CommandOptionManager
  attr_reader :full_names, :short_names

  def initialize
    @full_names = {}
    @short_names = {}
    @options = []
  end


  def add_option option
    if @full_names.include? option.full_name
      puts "Option Initialize Fail. Option FullName Exist. Option Name = #{option.full_name}"
      return
    end

    if option.short_name_exist?
      if @short_names.include? option.short_name
        puts "Option Initialize Fail. Option ShortName Exist. Option Name = #{option.short_name}"
        return
      else
        @short_names[option.short_name.to_sym] = option
      end
    end

    @options.push option
    @full_names[option.full_name.to_sym] = option
  end

end