require "slack_valid_block_kit/builder/compositions"
require "slack_valid_block_kit/builder/elements"
require "slack_valid_block_kit/builder/layouts"
require "slack_valid_block_kit/builder/surfaces"

module SlackValidBlockKit
  module Builder
    class Runner
      include ::SlackValidBlockKit::Builder::Surfaces
      include ::SlackValidBlockKit::Builder::Layouts
      include ::SlackValidBlockKit::Builder::Elements
      include ::SlackValidBlockKit::Builder::Compositions
    end
  end
end
