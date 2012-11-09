require 'commands/base'

module Commands
  class Finish < Base

    def run!
      super

      unless story_id
        put "Branch name must contain a Pivotal Tracker story id"
        return 1
      end

      if confirm_should_finish_story?
        topic_branch = current_branch

        put "Switching to master"
        sys "git checkout master"

        put "Destroying local branch"
        local_branch_deleted_successfully = sys "git branch -d #{topic_branch}"

        if local_branch_deleted_successfully
          put "Destroying remote branch"
          sys "git push origin :#{topic_branch}"

          put "Marking Story #{story_id} as finished..."
          if !story.update(:current_state => finished_state)
            put "Unable to mark Story #{story_id} as finished"
            return 1
          end
        else
          put "The local branch could not be deleted.  Please make sure your changes have been merged."
          return 1
        end
      end

      return 0
    end

  protected

    def confirm_should_finish_story?
      put "Finish story #{story_id} and delete local and remote branches? (y/N): ", false
      finish_story = get_char.strip.downcase
      finish_story == 'y'
    end

    def finished_state
      if story.story_type == "chore"
        "accepted"
      else
        "finished"
      end
    end

    def story_id
      match = current_branch[/\d+/] and match.to_i
    end

    def story
      @story ||= project.stories.find(story_id)
    end
  end
end
