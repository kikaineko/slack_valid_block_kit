require "slack_valid_block_kit/validator/base"
require "slack_valid_block_kit/validator/composition"
require "slack_valid_block_kit/validator/element"
require "slack_valid_block_kit/validator/error"
require "slack_valid_block_kit/validator/layout"
require "slack_valid_block_kit/validator/multi_select_menu"
require "slack_valid_block_kit/validator/select_menu"
require "slack_valid_block_kit/validator/surface"
require "slack_valid_block_kit/validator/uniq"

module SlackValidBlockKit
  module Validator
    class Runner
      include ::SlackValidBlockKit::Validator::Base
      include ::SlackValidBlockKit::Validator::Layout
      include ::SlackValidBlockKit::Validator::Element
      include ::SlackValidBlockKit::Validator::MultiSelectMenu
      include ::SlackValidBlockKit::Validator::SelectMenu
      include ::SlackValidBlockKit::Validator::Composition
      include ::SlackValidBlockKit::Validator::Surface
      include ::SlackValidBlockKit::Validator::Uniq

      attr_accessor :errors_by_path, :path_by_block_id, :path_by_action_id, :focus_on_load_by_path
      def initialize
        self.errors_by_path = {}
        self.path_by_block_id = {}
        self.path_by_action_id = {}
        self.focus_on_load_by_path = {}
      end
    end
  end
end
