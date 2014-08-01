module GLI
  module Commands
    module Sorters
      class Manual
        def sort(list)
          return list
        end
      end

      class Alpha
        def sort(list)
          return list.sort
        end
      end

      class Categories
        def initialize(app)
          @app = app
        end

        def sort(list)
          # Handle the special case of everything that has no categories
          return list unless list.first.is_a? Command

          # Get the hash of categories
          map = Hash.new.tap do |hash|
            list.each do |cmd|
              category = cmd.help_category || @app.default_help_category.name
              hash[category] ||= []
              hash[category] << cmd
            end
          end

          # If there is only one used category, simply return the embedded list
          map.each_value {|v| return v} if map.size == 1

          # Now, create an array so that we get the right order (order of definition)
          # and with the right category name (either the description or the name)
          [].tap do |list|
            done = []

            # Registered categories first
            @app.help_categories_order.each do |category|
              if map.has_key? category.name then
                list << [category.display, map[category.name]]
                done << category.name
              end
            end

            # Unregistered (if any) last
            if list.size < map.size then
              map.each_pair do |name,commands|
                list << [name,commands] unless done.include? name
              end
            end
          end
        end
      end
    end
  end
end
