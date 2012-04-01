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
      
      colwidth = 74
      
      put "\nDescription:\n"
      put wrap_text("#{story.description}\n", colwidth).gsub(/^/, '  ').chomp

      if options[:comments]
        put "\nComments:\n"
        story.notes.all.each do |note|
          @output.printf "  %-37s%37s\n\n", note.author, note.noted_at.strftime("%b %e, %Y %k:%M%p")
          put wrap_text(note.text, colwidth - 2).gsub(/^/, '    ')
        end
      end
      
      return 0
    end

  protected
  
    def wrap_text(txt, col = 80)
      txt.gsub(/(.{1,#{col}})( +|$\n?)|(.{1,#{col}})/,
        "\\1\\3\n") 
    end  

    def on_parse(opts)
      opts.on("-c", "--comments", "Display comments"){ |v| options[:comments] = v }
    end

    def story_id
      @story_id || current_branch[/\d+/]
    end

    def story
      @story ||= project.stories.find(story_id)
    end
  end
end
