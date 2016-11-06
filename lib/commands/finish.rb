require 'commands/base'

module Commands
  class Finish < Base

    def run!
      super

      unless story_id
        put "Branch name must contain a Pivotal Tracker story id"
        return 1
      end

      put "Marking Story #{story_id} as finished..."
      if story.update(:current_state => finished_state)
        put "Merging #{current_branch} into #{integration_branch}"
        sys "git checkout #{integration_branch}"
        sys "git merge --no-ff -m \"[##{story_id}] Merge branch '#{current_branch}' into #{integration_branch}\" #{current_branch}"

        topic_branch = Regexp.quote(current_branch)

        put "Destroying local branch"
        local_branch_deleted_successfully = sys "git branch -d #{topic_branch}"

        if local_branch_deleted_successfully
          put "Destroying remote branch"
          sys "git push origin :#{topic_branch}"
        else
          put "The local branch could not be deleted.  Please make sure your changes have been merged."
          return 1
        end
      else
        put "Unable to mark Story #{story_id} as finished"
        return 1
      end

      return 0
    end

  protected

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
