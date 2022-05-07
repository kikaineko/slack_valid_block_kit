require 'test_helper'

module Validator
  class LayoutTest < Minitest::Test
    def test_required_elements
      errors_by_path = ::SlackValidBlockKit.validate({ type: "modal", blocks: [{ type: "actions"}] })
      assert_equal :required, errors_by_path['root(modal).blocks[0](actions).elements'].first.kind
    end

    def test_max_size_of_elements
      blocks = [{
        type: "actions",
        elements: [
          {}, {}, {}, {}, {}, {}, {}, {}, {}, {},
          {}, {}, {}, {}, {}, {}, {}, {}, {}, {},
          {}, {}, {}, {}, {}, {}, {}, {}, {}, {},
        ]
      }]
      errors_by_path = ::SlackValidBlockKit.validate({ type: "modal", blocks: blocks })
      assert_equal :max_size, errors_by_path['root(modal).blocks[0](actions).elements'].first.kind
    end

    def test_content_in_elements
      blocks = [{
        type: "actions",
        elements: [{ type: "button" }]
      }]
      errors_by_path = ::SlackValidBlockKit.validate({ type: "modal", blocks: blocks })
      assert_equal :required, errors_by_path['root(modal).blocks[0](actions).elements[0](button).text'].first.kind
    end

    def test_long_text_button
      blocks = [{
        type: "actions",
        elements: [{ type: "button", text: { type: "plain_text", text: "x" * 76 } }]
      }]
      errors_by_path = ::SlackValidBlockKit.validate({ type: "modal", blocks: blocks })
      assert_equal :max_size, errors_by_path['root(modal).blocks[0](actions).elements[0](button).text(plain_text).text'].first.kind
    end

    def test_invalid_type_in_elements
      blocks = [{
        type: "actions",
        elements: [{ type: "xxxx" }]
      }]
      errors_by_path = ::SlackValidBlockKit.validate({ type: "modal", blocks: blocks })
      assert_equal :invalid_type, errors_by_path['root(modal).blocks[0](actions).elements[0].type'].first.kind
    end
  end
end
