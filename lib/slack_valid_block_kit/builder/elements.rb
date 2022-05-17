require 'date'

module SlackValidBlockKit
  module Builder
    module Elements
      def button(text:, action_id:, url: nil, value: nil, style: nil, confirm: nil, accessibility_label: nil)
        hash = { type: 'button' }
        hash[:text] = text
        hash[:action_id] = action_id.is_a?(Symbol) ? action_id.to_s : action_id
        hash[:url] = url unless url.nil?
        hash[:value] = value unless value.nil?
        hash[:style] = style unless style.nil?
        hash[:confirm] = confirm unless confirm.nil?
        hash[:accessibility_label] = accessibility_label unless accessibility_label.nil?
        hash
      end

      def checkboxes(action_id:, options:, initial_options: nil, confirm: nil, focus_on_load: nil)
        hash = { type: 'checkboxes' }
        hash[:action_id] = action_id.is_a?(Symbol) ? action_id.to_s : action_id
        hash[:options] = options
        hash[:initial_options] = initial_options unless initial_options.nil?
        hash[:confirm] = confirm unless confirm.nil?
        hash[:focus_on_load] = focus_on_load unless focus_on_load.nil?
        hash
      end

      def datepicker(action_id:, placeholder: nil, initial_date: nil, confirm: nil, focus_on_load: nil)
        hash = { type: 'datepicker' }
        hash[:action_id] = action_id.is_a?(Symbol) ? action_id.to_s : action_id
        hash[:placeholder] = placeholder unless placeholder.nil?
        unless initial_date.nil?
          if initial_date.is_a?(Date)
            hash[:initial_date] = initial_date.to_s
          elsif initial_date.is_a?(Time)
            hash[:initial_date] = initial_date.to_date.to_s
          else
            hash[:initial_date] = initial_date
          end
        end
        hash[:confirm] = confirm unless confirm.nil?
        hash[:focus_on_load] = focus_on_load unless focus_on_load.nil?
        hash
      end

      def image(image_url:, alt_text:)
        hash = { type: 'image' }
        hash[:image_url] = image_url
        hash[:alt_text] = alt_text
        hash
      end

      def multi_static_select(placeholder:, action_id:, options:, option_groups: nil, initial_options: nil, confirm: nil, max_selected_items: nil, focus_on_load: nil)
        hash = { type: 'multi_static_select' }
        hash[:placeholder] = placeholder
        hash[:action_id] = action_id.is_a?(Symbol) ? action_id.to_s : action_id
        hash[:options] = options
        hash[:option_groups] = option_groups unless option_groups.nil?
        hash[:initial_options] = initial_options unless initial_options.nil?
        hash[:confirm] = confirm unless confirm.nil?
        hash[:max_selected_items] = max_selected_items unless max_selected_items.nil?
        hash[:focus_on_load] = focus_on_load unless focus_on_load.nil?
        hash
      end

      def multi_external_select(placeholder:, action_id:, min_query_length: nil, initial_options: nil, confirm: nil, max_selected_items: nil, focus_on_load: nil)
        hash = { type: 'multi_external_select' }
        hash[:placeholder] = placeholder
        hash[:action_id] = action_id.is_a?(Symbol) ? action_id.to_s : action_id
        hash[:min_query_length] = min_query_length unless min_query_length.nil?
        hash[:initial_options] = initial_options unless initial_options.nil?
        hash[:confirm] = confirm unless confirm.nil?
        hash[:max_selected_items] = max_selected_items unless max_selected_items.nil?
        hash[:focus_on_load] = focus_on_load unless focus_on_load.nil?
        hash
      end

      def multi_users_select(placeholder:, action_id:, initial_users: nil, confirm: nil, max_selected_items: nil, focus_on_load: nil)
        hash = { type: 'multi_users_select' }
        hash[:placeholder] = placeholder
        hash[:action_id] = action_id.is_a?(Symbol) ? action_id.to_s : action_id
        hash[:initial_users] = initial_users unless initial_users.nil?
        hash[:confirm] = confirm unless confirm.nil?
        hash[:max_selected_items] = max_selected_items unless max_selected_items.nil?
        hash[:focus_on_load] = focus_on_load unless focus_on_load.nil?
        hash
      end

      def multi_conversations_select(placeholder:, action_id:, initial_conversations: nil, default_to_current_conversation: nil, confirm: nil, max_selected_items: nil, filter: nil, focus_on_load: nil)
        hash = { type: 'multi_conversations_select' }
        hash[:placeholder] = placeholder
        hash[:action_id] = action_id.is_a?(Symbol) ? action_id.to_s : action_id
        hash[:initial_conversations] = initial_conversations unless initial_conversations.nil?
        hash[:default_to_current_conversation] = default_to_current_conversation unless default_to_current_conversation.nil?
        hash[:confirm] = confirm unless confirm.nil?
        hash[:max_selected_items] = max_selected_items unless max_selected_items.nil?
        hash[:filter] = filter unless filter.nil?
        hash[:focus_on_load] = focus_on_load unless focus_on_load.nil?
        hash
      end

      def multi_channels_select(placeholder:, action_id:, initial_channels: nil, confirm: nil, max_selected_items: nil, focus_on_load: nil)
        hash = { type: 'multi_channels_select' }
        hash[:placeholder] = placeholder
        hash[:action_id] = action_id.is_a?(Symbol) ? action_id.to_s : action_id
        hash[:initial_channels] = initial_channels unless initial_channels.nil?
        hash[:confirm] = confirm unless confirm.nil?
        hash[:max_selected_items] = max_selected_items unless max_selected_items.nil?
        hash[:focus_on_load] = focus_on_load unless focus_on_load.nil?
        hash
      end

      def overflow(options:, action_id:, confirm: nil)
        hash = { type: 'overflow' }
        hash[:options] = options
        hash[:action_id] = action_id.is_a?(Symbol) ? action_id.to_s : action_id
        hash[:confirm] = confirm unless confirm.nil?
        hash
      end

      def plain_text_input(action_id:, placeholder: nil, initial_value: nil, multiline: nil, min_length: nil, max_length: nil, dispatch_action_config: nil, focus_on_load: nil)
        hash = { type: 'plain_text_input' }
        hash[:action_id] = action_id.is_a?(Symbol) ? action_id.to_s : action_id
        hash[:placeholder] = placeholder unless placeholder.nil?
        hash[:initial_value] = initial_value unless initial_value.nil?
        hash[:multiline] = multiline unless multiline.nil?
        hash[:min_length] = min_length unless min_length.nil?
        hash[:max_length] = max_length unless max_length.nil?
        hash[:dispatch_action_config] = dispatch_action_config unless dispatch_action_config.nil?
        hash[:focus_on_load] = focus_on_load unless focus_on_load.nil?
        hash
      end

      def radio_buttons(options:, action_id:, initial_option: nil, confirm: nil, focus_on_load: nil)
        hash = { type: 'radio_buttons' }
        hash[:options] = options
        hash[:action_id] = action_id.is_a?(Symbol) ? action_id.to_s : action_id
        hash[:initial_option] = initial_option unless initial_option.nil?
        hash[:confirm] = confirm unless confirm.nil?
        hash[:focus_on_load] = focus_on_load unless focus_on_load.nil?
        hash
      end

      def static_select(placeholder:, action_id:, options:, option_groups: nil, initial_option: nil, confirm: nil, focus_on_load: nil)
        hash = { type: 'static_select' }
        hash[:placeholder] = placeholder
        hash[:action_id] = action_id.is_a?(Symbol) ? action_id.to_s : action_id
        hash[:options] = options
        hash[:option_groups] = option_groups unless option_groups.nil?
        hash[:initial_option] = initial_option unless initial_option.nil?
        hash[:confirm] = confirm unless confirm.nil?
        hash[:focus_on_load] = focus_on_load unless focus_on_load.nil?
        hash
      end

      def external_select(placeholder:, action_id:, min_query_length: nil, initial_option: nil, confirm: nil, focus_on_load: nil)
        hash = { type: 'external_select' }
        hash[:placeholder] = placeholder
        hash[:action_id] = action_id.is_a?(Symbol) ? action_id.to_s : action_id
        hash[:min_query_length] = min_query_length unless min_query_length.nil?
        hash[:initial_option] = initial_option unless initial_option.nil?
        hash[:confirm] = confirm unless confirm.nil?
        hash[:focus_on_load] = focus_on_load unless focus_on_load.nil?
        hash
      end

      def users_select(placeholder:, action_id:, initial_user: nil, confirm: nil, focus_on_load: nil)
        hash = { type: 'users_select' }
        hash[:placeholder] = placeholder
        hash[:action_id] = action_id.is_a?(Symbol) ? action_id.to_s : action_id
        hash[:initial_user] = initial_user unless initial_user.nil?
        hash[:confirm] = confirm unless confirm.nil?
        hash[:focus_on_load] = focus_on_load unless focus_on_load.nil?
        hash
      end

      def conversations_select(placeholder:, action_id:, initial_conversation: nil, default_to_current_conversation: nil, confirm: nil, response_url_enabled: nil, filter: nil, focus_on_load: nil)
        hash = { type: 'conversations_select' }
        hash[:placeholder] = placeholder
        hash[:action_id] = action_id.is_a?(Symbol) ? action_id.to_s : action_id
        hash[:initial_conversation] = initial_conversation unless initial_conversation.nil?
        hash[:default_to_current_conversation] = default_to_current_conversation unless default_to_current_conversation.nil?
        hash[:confirm] = confirm unless confirm.nil?
        hash[:response_url_enabled] = response_url_enabled unless response_url_enabled.nil?
        hash[:filter] = filter unless filter.nil?
        hash[:focus_on_load] = focus_on_load unless focus_on_load.nil?
        hash
      end

      def channels_select(placeholder:, action_id:, initial_channel: nil, confirm: nil, response_url_enabled: nil, focus_on_load: nil)
        hash = { type: 'channels_select' }
        hash[:placeholder] = placeholder
        hash[:action_id] = action_id.is_a?(Symbol) ? action_id.to_s : action_id
        hash[:initial_channel] = initial_channel unless initial_channel.nil?
        hash[:confirm] = confirm unless confirm.nil?
        hash[:response_url_enabled] = response_url_enabled unless response_url_enabled.nil?
        hash[:focus_on_load] = focus_on_load unless focus_on_load.nil?
        hash
      end

      def timepicker(action_id:, placeholder: nil, initial_time: nil, confirm: nil, focus_on_load: nil)
        hash = { type: 'timepicker' }
        hash[:action_id] = action_id.is_a?(Symbol) ? action_id.to_s : action_id
        hash[:placeholder] = placeholder unless placeholder.nil?
        unless initial_time.nil?
          if initial_time.is_a?(Time)
            hash[:initial_time] = initial_time.strftime("%H:%M")
          else
            hash[:initial_time] = initial_time
          end
        end
        hash[:confirm] = confirm unless confirm.nil?
        hash[:focus_on_load] = focus_on_load unless focus_on_load.nil?
        hash
      end
    end
  end
end
