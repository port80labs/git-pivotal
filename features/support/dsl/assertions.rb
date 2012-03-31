module GitPivotal
  module FeatureHelpers
    module Assertions
      def assert_card_is_started(id)
        pivotal_project.stories.find(id).current_state.should eq("started")
      end
    end
  end
end

World(GitPivotal::FeatureHelpers::Assertions)
