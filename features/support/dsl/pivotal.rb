module GitPivotal
  module FeatureHelpers
    module Pivotal
      def pivotal_project
        data[:pivotal_project] ||= (
          PivotalTracker::Client.token = PIVOTAL_API_KEY
          PivotalTracker::Project.find(PIVOTAL_TEST_PROJECT))
      end
      
      def created_cards
        data[:created_cards] ||= []
      end
      
      def delete_created_cards
       created_cards.each { |card| (card.delete rescue nil) }
      end
      
      def current_card
        data[:current_card]
      end
      
      def refresh_current_card!
        set_current_card pivotal_project.stories.find(current_card.id)
      end
      
      def set_current_card(card)
        data[:current_card] = card
      end
      
      def create_test_story(type, options = {})
        attrs = {
          :name          => "a #{type}",
          :story_type    => type.to_s,
          :current_state => "unstarted",
          :estimate      => (type.to_s == "feature" ? 1 : nil)
        }.merge(options)
        
        story = pivotal_project.stories.create(attrs)
        set_current_card story
        created_cards << story
        
        # let data propagate on Pivotal
        sleep 4
        pivotal_project.stories.find(story.id)

        story
      end
      
      def comment_on_story(options = {})
        current_card.notes.create options

        # let data propagate on Pivotal
        sleep 4
      end

      def update_test_story(options = {})
        story = current_card || create_test_story("feature")
        attrs = {
          :current_state => "unstarted",
          :estimate      => (story.story_type.to_s == "feature" ? 1 : nil)
        }.merge(options)

        story.update(attrs)

        # let data propagate on Pivotal
        sleep 4
        pivotal_project.stories.find(story.id)
        
        story
      end
      
    end
  end
end

World(GitPivotal::FeatureHelpers::Pivotal)