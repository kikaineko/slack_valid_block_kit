module SlackValidBlockKit
  module Builder
    module MethodGenerator
      def self.generate(name, is_typed, required: [], optional: [])
        args = required.map { |p| "#{p}:" } + optional.map { |p| "#{p}: nil" }
        first_hash = is_typed ? "{ type: '#{name}' }" : "{}"
        set_stmts = required.map { |p| "  hash[:#{p}] = #{p}" }
        set_stmts += optional.map { |p| "  hash[:#{p}] = #{p} unless #{p}.nil?" }
        <<~EOD
          def #{name}(#{args.join(', ')})
            hash = #{first_hash}
          #{set_stmts.join("\n")}
            hash
          end
        EOD
      end

      def self.generate_surfaces(indent_level = 0)
        indent = "  " * indent_level
        arr = []
        arr << generate("modal", true, required: %w(title blocks), optional: %w(close submit private_metadata callback_id clear_on_close notify_on_close external_id submit_disabled))
        arr << generate("home", true, required: %w(blocks), optional: %w(private_metadata callback_id external_id))
        arr << generate("blocks", false, required: %w(blocks), optional: [])
        indent + arr.join("\n#{indent}")
      end

      def self.generate_layouts(indent_level = 0)
        indent = "  " * indent_level
        arr = []
        arr << generate("actions", true, required: %w(elements), optional: %w(block_id))
        arr << generate("context", true, required: %w(elements), optional: %w(block_id))
        arr << generate("divider", true, required: [], optional: %w(block_id))
        arr << generate("file", true, required: %w(elements source), optional: %w(block_id))
        arr << generate("header", true, required: %w(text), optional: %w(block_id))
        arr << generate("image", true, required: %w(image_url alt_text), optional: %w(title block_id))
        arr << generate("input", true, required: %w(label element), optional: %w(dispatch_action block_id hint optional))
        arr << generate("section", true, required: [], optional: %w(text block_id fields accessory))

        indent + arr.join("\n#{indent}")
      end

      def self.generate_elements(indent_level = 0)
        indent = "  " * indent_level
        arr = []
        arr << generate("button", true, required: %w(text action_id), optional: %w(url value style confirm accessibility_label))
        arr << generate("checkboxes", true, required: %w(action_id options), optional: %w(initial_options confirm focus_on_load))
        arr << generate("datepicker", true, required: %w(action_id), optional: %w(placeholder initial_date confirm focus_on_load))
        arr << generate("image", true, required: %w(image_url alt_text), optional: [])

        arr << generate("multi_static_select", true, required: %w(placeholder action_id options), optional: %w(option_groups initial_options confirm max_selected_items focus_on_load))
        arr << generate("multi_external_select", true, required: %w(placeholder action_id), optional: %w(min_query_length initial_options confirm max_selected_items focus_on_load))
        arr << generate("multi_users_select", true, required: %w(placeholder action_id), optional: %w(initial_users confirm max_selected_items focus_on_load))
        arr << generate("multi_conversations_select", true, required: %w(placeholder action_id), optional: %w(initial_conversations default_to_current_conversation confirm max_selected_items filter focus_on_load))
        arr << generate("multi_channels_select", true, required: %w(placeholder action_id), optional: %w(initial_channels confirm max_selected_items focus_on_load))

        arr << generate("overflow", true, required: %w(options action_id), optional: %w(confirm))
        arr << generate("plain_text_input", true, required: %w(action_id), optional: %w(placeholder initial_value multiline min_length max_length dispatch_action_config focus_on_load))
        arr << generate("radio_buttons", true, required: %w(options action_id), optional: %w(initial_option confirm focus_on_load))

        arr << generate("static_select", true, required: %w(placeholder action_id options), optional: %w(option_groups initial_option confirm focus_on_load))
        arr << generate("external_select", true, required: %w(placeholder action_id), optional: %w(min_query_length initial_option confirm focus_on_load))
        arr << generate("users_select", true, required: %w(placeholder action_id), optional: %w(initial_user confirm focus_on_load))
        arr << generate("conversations_select", true, required: %w(placeholder action_id), optional: %w(initial_conversation default_to_current_conversation confirm response_url_enabled filter focus_on_load))
        arr << generate("channels_select", true, required: %w(placeholder action_id), optional: %w(initial_channel confirm response_url_enabled focus_on_load))

        arr << generate("timepicker", true, required: %w(action_id), optional: %w(placeholder initial_time confirm focus_on_load))

        indent + arr.join("\n#{indent}")
      end

      def self.generate_composition(indent_level = 0)
        indent = "  " * indent_level
        arr = []
        arr << generate("plain_text", true, required: %w(text), optional: %w(emoji))
        arr << generate("mrkdwn", true, required: %w(text), optional: %w(verbatim))
        arr << generate("confirmation", false, required: %w(title text confirm deny), optional: %w(style))
        arr << generate("option", false, required: %w(text value), optional: %w(description url))
        arr << generate("option_group", false, required: %w(label options), optional: [])
        arr << generate("dispatch_action_configuration", false, required: [], optional: %w(trigger_actions_on))
        arr << generate("filter", false, required: [], optional: %w(include exclude_external_shared_channels exclude_bot_users))

        indent + arr.join("\n#{indent}")
      end
    end
  end
end
