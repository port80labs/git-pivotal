require 'commands/map'
require 'commands/bug'
require 'commands/card'
require 'commands/chore'
require 'commands/feature'
require 'commands/story'

module Commands
  class Start
    COMMAND_MAP = Map.new.merge({
      "bug"     => Commands::Bug,
      "chore"   => Commands::Chore,
      "feature" => Commands::Feature,
      "story"   => Commands::Story,
      /^\d+$/   => Commands::Card
    })
    
    class << self
      def for(*args)
        identifier = args.shift
        construct_instance_for(identifier, args) || display_usage_instructions_and_quit(identifier)
      end
      
      private
      
      def construct_instance_for(identifier, args)
        if klass=COMMAND_MAP[identifier]
          instance = klass.new(*args)
          instance.story_id = identifier if instance.respond_to?(:story_id=)
          instance
        end
      end

      def display_usage_instructions_and_quit(identifier)
        puts "ERROR: Unknown card identifier given: '#{identifier}'.  Valid options are 'story', 'bug', 'chore', 'feature', or the card number."
        exit 1
      end
    end
  end

end
