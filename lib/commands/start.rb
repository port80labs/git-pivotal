require 'commands/map'
require 'commands/bug'
require 'commands/card'
require 'commands/chore'
require 'commands/feature'

module Commands
  class Start
    COMMAND_MAP = Map.new.merge({
      "bug"     => Commands::Bug,
      "chore"   => Commands::Chore,
      "feature" => Commands::Feature,
      /^\d+$/   => Commands::Card
    })
    
    class << self
      def for(*args)
        identifier = args.shift
        construct_instance_for(identifier, args) || 
          raise(ArgumentError, "Unknown card identifier given: #{identifier}")
      end
      
      private
      
      def construct_instance_for(identifier, args)
        if klass=COMMAND_MAP[identifier]
          instance = klass.new(*args)
          instance.story_id = identifier if instance.respond_to?(:story_id=)
          instance
        end
      end
    end
  end

end