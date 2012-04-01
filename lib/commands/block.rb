require 'commands/base'

module Commands
  class Block < Base
    Label = "blocked"
    MessagePrefix = "Blocked:"
    
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
      
      if story.labels.to_s.include?(Label)
        put "Story #{story_id} is already blocked."
        return 0
      end
      
      message = options[:message].to_s

      if message.empty?
        loop do
          put "What's the reason for blocking this story?"
          message = input.gets.chomp
          break unless message.empty?
          put ""
        end
      end
      
      labels = story.labels.to_s.split(",").concat([Label]).join(",")
      story.update :labels => labels
      story.notes.create :author => full_name, :text => "#{MessagePrefix} #{message}"
      put "Story #{story_id} has been blocked."

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
