module SlackValidBlockKit::Validator
  module MultiSelectMenu
    MULTI_STATIC_SELECT_PROPERTIES = %i(type placeholder action_id options option_groups initial_options confirm max_selected_items focus_on_load)
    MULTI_EXTERNAL_SELECT_PROPERTIES = %i(type placeholder action_id min_query_length initial_options confirm max_selected_items focus_on_load)
    MULTI_USERS_SELECT_PROPERTIES = %i(type placeholder action_id initial_users confirm max_selected_items focus_on_load)
    MULTI_CONVERSATIONS_SELECT_PROPERTIES = %i(type placeholder action_id initial_conversations default_to_current_conversation confirm max_selected_items filter focus_on_load)
    MULTI_CHANNELS_SELECT_PROPERTIES = %i(type placeholder action_id initial_channels confirm max_selected_items focus_on_load)

    def validate_multi_static_select(hash, path, options = nil)
      validate_for_properties(hash, path, MULTI_STATIC_SELECT_PROPERTIES)
      validate_for(hash[:type], "#{path}.type", String, true, only: ["multi_static_select"])

      validate_for(hash[:options], "#{path}.options", Array, false, max: 100)
      options = Array(hash[:options])
      options.each_with_index do |e, i|
        validate_option(e, "#{path}.options[#{i}]", { text_type: :text_objects })
      end

      validate_for(hash[:option_groups], "#{path}.option_groups", Array, false, max: 100)
      option_groups = Array(hash[:option_groups])
      option_groups.each_with_index do |e, i|
        validate_option_group(e, "#{path}.option_groups[#{i}]")
      end

      if hash[:options].nil? && hash[:option_groups].nil?
        add_error(path, :require_options_or_option_groups)
      end

      validate_for_initial_option_of_multi_static_select(hash[:initial_options], "#{path}.initial_options", options: options, option_groups: option_groups)

      validate_common_for_multi_select(hash, path, options)
    end

    def validate_multi_external_select(hash, path, options = nil)
      validate_for_properties(hash, path, MULTI_EXTERNAL_SELECT_PROPERTIES)
      validate_for(hash[:type], "#{path}.type", String, true, only: ["multi_external_select"])

      validate_for(hash[:min_query_length], "#{path}.min_query_length", Integer, false)
      validate_for(hash[:initial_options], "#{path}.initial_options", Array, false)

      validate_common_for_multi_select(hash, path, options)
    end

    def validate_multi_users_select(hash, path, options = nil)
      validate_for_properties(hash, path, MULTI_USERS_SELECT_PROPERTIES)
      validate_for(hash[:type], "#{path}.type", String, true, only: ["multi_users_select"])

      validate_for(hash[:initial_users], "#{path}.initial_users", :array_of_string, false)

      validate_common_for_multi_select(hash, path, options)
    end

    def validate_multi_conversations_select(hash, path, options = nil)
      validate_for_properties(hash, path, MULTI_CONVERSATIONS_SELECT_PROPERTIES)
      validate_for(hash[:type], "#{path}.type", String, true, only: ["multi_conversations_select"])

      validate_for(hash[:initial_conversations], "#{path}.initial_conversations", :array_of_string, false)
      validate_for(hash[:default_to_current_conversation], "#{path}.default_to_current_conversation", :bool, false)
      validate_filter(hash["filter"], "#{path}.filter") unless hash["filter"].nil?

      validate_common_for_multi_select(hash, path, options)
    end

    def validate_multi_channels_select(hash, path, options = nil)
      validate_for_properties(hash, path, MULTI_CHANNELS_SELECT_PROPERTIES)
      validate_for(hash[:type], "#{path}.type", String, true, only: ["multi_channels_select"])

      validate_for(hash[:initial_channels], "#{path}.initial_channels", :array_of_string, false)

      validate_common_for_multi_select(hash, path, options)
    end

    private def validate_common_for_multi_select(hash, path, options = nil)
      validate_for_plain_text(hash[:placeholder], "#{path}.placeholder", true, 150)

      validate_for_action_id(hash[:action_id], "#{path}.action_id")

      validate_for(hash[:confirm], "#{path}.confirm", Hash, false)
      validate_confirmation(hash[:confirm], "#{path}.confirm") unless hash[:confirm].nil?
      validate_for(hash[:max_selected_items], "#{path}.max_selected_items", Integer, false, min: 1)
      validate_focus_on_load(hash[:focus_on_load], "#{path}.focus_on_load")
    end

    private def validate_for_initial_option_of_multi_static_select(obj, path, options:, option_groups:)
      return if obj.nil?

      if !obj.is_a?(Array)
        add_error(path, :clazz_type, Array)
        return
      end

      if obj.respond_to?(:size) && obj.size == 0
        add_error(path, :no_item)
        return
      end

      candidate_groups = option_groups.map { |v| v[:options] } + [options]
      used_groups = candidate_groups.select { |g| (obj - g).size == 0 }
      if used_groups.size == 0
        add_error(path, :must_be_one_of_the_provided_options)
      end
    end
  end
end
