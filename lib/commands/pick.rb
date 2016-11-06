require 'commands/base'

module Commands
  class Pick < Base

    def type
      raise Error("must define in subclass")
    end

    def plural_type
      raise Error("must define in subclass")
    end

    def branch_suffix
      raise Error("must define in subclass")
    end

    def run!
      response = super
      return response if response > 0

      if story
        put "Story: #{story.name}"
        put "URL:   #{story.url}\n"

        if confirm_should_start_story?
          put "Updating #{type} status in Pivotal Tracker..."
          story.update(:owned_by => options[:full_name], :current_state => :started)

          if story.errors.empty?
            branch_name = get_branch_name
            create_branch(branch_name)
          else
            put "Unable to mark #{type} as started"
            put "\t" + story.errors.to_a.join("\n\t")
            return 1
          end
        end
      else
        put "No #{plural_type} available!"
      end

      return 0
    end

    protected

    def confirm_should_start_story?
      return true if options[:force]

      put "Start #{type} #{story.id} - #{story.name}? (Y/n): ", false
      start_story = get_char.strip.downcase
      start_story == '' || start_story == 'y'
    end

    def story
      if @story.nil?
        msg = "Retrieving latest #{plural_type} from Pivotal Tracker"
        msg += " for #{options[:full_name]}" if options[:only_mine]
        put "#{msg}..."

        conditions = { :current_state => "unstarted", :limit => 1, :offset => 0 }
        conditions.merge!(:story_type => type) unless type == "story"
        conditions[:owned_by] = options[:full_name] if options[:only_mine]
        @story = project.stories.all(conditions).first
      end
      @story
    end

    def get_branch_name
      branch_name = ""
      suggested_branch_name = "#{story.id}-#{story.name.downcase.gsub(/\s+/, "-")}"

      unless options[:quiet] || options[:defaults]
        put "Enter branch name [#{suggested_branch_name}]: ", false
        branch_name = input.gets.chomp.strip
      end

      branch_name == "" ? suggested_branch_name : branch_name
    end

    def create_branch(branch)
      branch = Regexp.quote(branch)
      if get("git branch").match(branch).nil?
        put "Creating remote branch '#{branch}'"
        sys "git push origin origin:refs/heads/#{branch}"
        sys "git fetch origin"

        put "Switched to a new branch '#{branch}'"
        sys "git branch #{branch}"
        sys "git checkout #{branch}"
      end
    end

  end
end
