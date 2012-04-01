require 'commands/base'

module Commands
  class Accept < Base
    def run!
      super

      unless story_id
        put "Branch name must contain a Pivotal Tracker story id"
        return 1
      end

      if story_is_acceptable?
        accept_story!
        return 0
      else
        put "Story is not in an acceptable state. It's currently #{story.current_state}."
        return 1
      end
    end

  protected
  
    def accept_story!
      put "Marking Story #{story_id} as accepted..."
      if story.update(:current_state => "accepted")
        topic_branch = current_branch
        
        put "Pushing #{topic_branch} to #{remote}"
        sys "git push --set-upstream #{remote} #{topic_branch}"
        
        put "Pulling #{integration_branch}..."
        sys "git checkout #{integration_branch}"
        sys "git pull"

        put "Merging #{topic_branch} into #{integration_branch}"
        sys "git merge --no-ff #{topic_branch}"
  
        put "Pushing #{integration_branch} to #{remote}"
        sys "git push"
      
        put "Now on #{integration_branch}."

        return 0
      else
        put "Unable to mark Story #{story_id} as finished"

        return 1
      end
    end
  
    def chore_and_acceptable?
      story.story_type == "chore" && story.current_state == "accepted"
    end
    
    def bug_and_acceptable?
      story.story_type == "bug" && %(finished delivered).include?(story.current_state)
    end
    
    def feature_and_acceptable?
      story.story_type == "feature" && %(finished delivered).include?(story.current_state)
    end
  
    def story_is_acceptable?
      chore_and_acceptable? || bug_and_acceptable? || feature_and_acceptable?
    end

    def story_id
      match = current_branch[/\d+/] and match.to_i
    end

    def story
      @story ||= project.stories.find(story_id)
    end
  end
end
