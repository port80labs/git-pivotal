require 'commands/base'
require 'commands/block'

module Commands
  class Unblock < Base
    PlaceholderLabel = "."
    
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
      
      unless story.labels.to_s.include?(Block::Label)
        put "Story #{story_id} is already unblocked."
        return 0
      end
      
      labels = story.labels.to_s.split(",") - [Block::Label]
      
      # this line is to work aroudn Pivotal Tracker's broken API for removing the last
      # label on a card. http://community.pivotaltracker.com/pivotal/topics/api_v3_cannot_remove_labels_from_a_story_anymore
      if labels.empty?
        labels << PlaceholderLabel
        put "Note: a '.' label will be placed on this card due to a bug in the v3 API of Pivotal Tracker."
      end
      
      story.update :labels => labels.join(",")
      put "Story #{story_id} has been unblocked."
      
      return 0
    end

  protected
  
    def on_parse(opts)
      opts.on("-m [String]", "--message [String]", "The message to provide when blocking a story."){ |m| options[:message] = m }
    end

    def story_id
      @story_id || current_branch[/\d+/]
    end

    def story
      @story ||= project.stories.find(story_id)
    end
  end
end
