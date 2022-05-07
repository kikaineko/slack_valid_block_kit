module SlackValidBlockKit::Validator
  module SelectMenu
    STATIC_SELECT_PROPERTIES = %i(type placeholder action_id options option_groups initial_options confirm focus_on_load)
    EXTERNAL_SELECT_PROPERTIES = %i(type placeholder action_id min_query_length initial_options confirm focus_on_load)
    USERS_SELECT_PROPERTIES = %i(type placeholder action_id initial_user confirm focus_on_load)
    CONVERSATIONS_SELECT_PROPERTIES = %i(type placeholder action_id initial_conversation default_to_current_conversation confirm response_url_enabled filter focus_on_load)
    CHANNELS_SELECT_PROPERTIES = %i(type placeholder action_id initial_channel confirm response_url_enabled focus_on_load)

    def validate_static_select(hash, path, options = nil)
      validate_for_properties(hash, path, STATIC_SELECT_PROPERTIES)
      validate_for(hash[:type], "#{path}.type", String, true, only: ["static_select"])

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

      validate_for_initial_option_of_multi_static_select(hash[:initial_option], "#{path}.initial_option", options: options, option_groups: option_groups)

      validate_common_for_select(hash, path, options)
    end

    def validate_external_select(hash, path, options = nil)
      validate_for_properties(hash, path, EXTERNAL_SELECT_PROPERTIES)
      validate_for(hash[:type], "#{path}.type", String, true, only: ["external_select"])

      validate_for(hash[:min_query_length], "#{path}.min_query_length", Integer, false)
      validate_for(hash[:initial_options], "#{path}.initial_options", Array, false)

      validate_common_for_select(hash, path, options)
    end

    def validate_users_select(hash, path, options = nil)
      validate_for_properties(hash, path, USERS_SELECT_PROPERTIES)
      validate_for(hash[:type], "#{path}.type", String, true, only: ["users_select"])

      validate_for(hash[:initial_user], "#{path}.initial_user", String, false)

      validate_common_for_select(hash, path, options)
    end

    def validate_conversations_select(hash, path, options = nil)
      validate_for_properties(hash, path, CONVERSATIONS_SELECT_PROPERTIES)
      validate_for(hash[:type], "#{path}.type", String, true, only: ["conversations_select"])

      validate_for(hash[:initial_conversation], "#{path}.initial_conversation", String, false)
      validate_for(hash[:default_to_current_conversation], "#{path}.default_to_current_conversation", :bool, false)
      validate_filter(hash["filter"], "#{path}.filter")
      validate_for(hash[:response_url_enabled], "#{path}.response_url_enabled", :bool, false)

      validate_common_for_select(hash, path, options)
    end

    def validate_channels_select(hash, path, options = nil)
      validate_for_properties(hash, path, CHANNELS_SELECT_PROPERTIES)
      validate_for(hash[:type], "#{path}.type", String, true, only: ["channels_select"])

      validate_for(hash[:initial_channel], "#{path}.initial_channel", String, false)
      validate_for(hash[:response_url_enabled], "#{path}.response_url_enabled", :bool, false)

      validate_common_for_select(hash, path, options)
    end

    private def validate_common_for_select(hash, path, options = nil)
      validate_for_plain_text(hash[:placeholder], "#{path}.placeholder", true, 150)

      validate_for_action_id(hash[:action_id], "#{path}.action_id")

      validate_for(hash[:confirm], "#{path}.confirm", Hash, false) unless hash[:confirm].nil?
      validate_confirmation(hash[:confirm], "#{path}.confirm")
      validate_focus_on_load(hash[:focus_on_load], "#{path}.focus_on_load")
    end

    private def validate_for_initial_option_of_multi_static_select(obj, path, options:, option_groups:)
      return if obj.nil?

      if !obj.is_a?(Hash)
        add_error(path, :clazz_type, Hash)
        return
      end

      candidate_groups = option_groups.map { |v| v[:options] } + [options]
      used_groups = candidate_groups.select { |g| ([obj] - g).size == 0 }
      if used_groups.size == 0
        add_error(path, :must_be_one_of_the_provided_options)
      end
    end
  end
end
