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

      def update_test_story(type, options = {})
        story = current_card || create_test_story("feature")
        attrs = {
          :story_type    => type.to_s,
          :current_state => "unstarted",
          :estimate      => (type.to_s == "feature" ? 1 : nil)
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