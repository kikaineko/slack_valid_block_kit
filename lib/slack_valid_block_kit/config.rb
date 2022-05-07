module SlackValidBlockKit
  class Config
    class << self
      def skip_validation=(v)
        @_skip_validation = v
      end

      def skip_validation
        @_skip_validation
      end
    end
  end
end
