require 'commands/pick'

module Commands
  class Card < Pick
    attr_accessor :story_id

    def type
      nil
    end
    
    def plural_type
      "cards"
    end
    
    def branch_suffix
      if story.story_type == "bug"
        "bugfix"
      else
        story.story_type
      end
    end

    protected
    
    def story
      return @story if @story
      raise ArgumentError, "No story id was given!" unless story_id
      project.stories.find(story_id)
    end

  end
end