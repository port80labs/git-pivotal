module GitPivotal
  module FeatureHelpers
    module Data
      def data
        @_dsl_data ||= {}
      end
    end
  end
end

World(GitPivotal::FeatureHelpers::Data)