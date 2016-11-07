require 'commands/base'

module Commands
  class Finish < Base

    def run!
      super

      unless story_id
        put "Branch name must contain a Pivotal Tracker story id"
        return 1
      end

      begin
        put "Marking Story #{story_id} as finished..."
        story.current_state = finished_state
        story.save
        put "Merging #{current_branch} into #{integration_branch}"
        sys "git checkout #{integration_branch}"
        sys "git merge --no-ff -m \"[##{story_id}] Merge branch '#{current_branch}' into #{integration_branch}\" #{current_branch}"

        put "Destroying local branch"
        local_branch_deleted_successfully = sys "git branch -d #{current_branch}"

        if !local_branch_deleted_successfully
          put "The local branch could not be deleted.  Please make sure your changes have been merged."
          return 1
        end
      rescue
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
      @story ||= project.story(story_id)
    end
  end
end
