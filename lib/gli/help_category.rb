module GLI
  class HelpCategory #:nodoc:

    attr_reader :name
    attr_reader :description
    attr_reader :options

    def initialize(name,description,options = [])
      @name = name
      @description = description
      @options = options
    end

    def default?
      @options.include? :default
    end

    def display
      if description.nil? || description.empty? then
        name
      else
        description
      end
    end
  end
end
