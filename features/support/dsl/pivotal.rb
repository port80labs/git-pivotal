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
        
        sleep(10) # let the data propagate
        story
      end

      def update_test_story(type, options = {})
        story = current_card || create_test_story("feature")
        story.update({
          :story_type    => type.to_s,
          :current_state => "unstarted",
          :estimate      => (type.to_s == "feature" ? 1 : nil)
        }.merge(options))
        sleep(4) # let the data propagate
      end
      
    end
  end
end

World(GitPivotal::FeatureHelpers::Pivotal)