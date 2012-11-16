require 'commands/pick'

module Commands
  class Story < Pick

    def type
      "story"
    end
    
    def plural_type
      "stories"
    end
    
    def branch_suffix
      "story"
    end

  end
end

