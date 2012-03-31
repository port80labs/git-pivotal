require 'commands/bug'
require 'commands/chore'
require 'commands/feature'

module Commands
  class Start
    COMMAND_MAP = { 
      "bug" => Commands::Bug, 
      "chore" => Commands::Chore, 
      "feature" => Commands::Feature 
    }
    
    def self.for(*args)
      card_type = args.first
      if klass=COMMAND_MAP[card_type]
        args.shift
        COMMAND_MAP[card_type].new(*args)
      else
        COMMAND_MAP[card_type] || raise(ArgumentError,"Unknown command type requested: #{card_type}")
      end
    end
  end

end