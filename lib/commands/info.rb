require 'commands/base'

module Commands
  class Info < Base
    
    def initialize(*args)
      @story_id = args.shift if args.first =~ /^(\d+)$/
      super(*args)
    end

    def run!
      super

      unless story_id
        put "No story id was supplied and you aren't on a topic branch!"
        return 1
      end

      put "Story:         #{story.name}"
      put "URL:           #{story.url}"
      put "Labels:        #{story.labels.split(',').join(', ')}" if story.labels
      put "State:         #{story.accepted_at ? 'accepted' : 'not accepted'}"
      
      description = story.description.sub(/^/, '  ').gsub(/\n/, "\n  ")
      put "Description:\n#{description}\n\n"

      return 0
    end

  protected

    def story_id
      @story_id || current_branch[/\d+/]
    end

    def story
      @story ||= project.stories.find(story_id)
    end
  end
end
