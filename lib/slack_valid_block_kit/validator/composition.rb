module SlackValidBlockKit::Validator
  module Composition
    PLAIN_TEXT_PROPERTIES = %i(type text emoji)
    MRKDWN_PROPERTIES = %i(type text verbatim)
    CONFIRMATION_PROPERTIES = %i(title text confirm deny style)
    OPTION_PROPERTIES = %i(text value description)
    OPTION_OF_OVERFLOW_PROPERTIES = %i(text value description url)
    OPTION_GROUP_PROPERTIES = %i(label options)
    FILTER_PROPERTIES = %i(include exclude_external_shared_channels exclude_bot_users)
    DISPATCH_ACTION_CONFIGURATION_PROPERTIES = %i(trigger_actions_on)

    def validate_plain_text(hash, path, options = nil)
      validate_for_properties(hash, path, PLAIN_TEXT_PROPERTIES)
      validate_for(hash[:type], "#{path}.type", String, true, only: ["plain_text"])
      max = options && options[:text_size]
      validate_for(hash[:text], "#{path}.text", String, true, max: max)
      validate_for(hash[:emoji], "#{path}.emoji", :bool, false)
    end

    def validate_mrkdwn(hash, path, options = nil)
      validate_for_properties(hash, path, MRKDWN_PROPERTIES)
      validate_for(hash[:type], "#{path}.type", String, true, only: ["mrkdwn"])
      max = options && options[:text_size]
      validate_for(hash[:text], "#{path}.text", String, true, max: max)
      validate_for(hash[:verbatim], "#{path}.verbatim", :bool, false)
    end

    def validate_confirmation(hash, path, options = nil)
      validate_for_properties(hash, path, CONFIRMATION_PROPERTIES)

      validate_for_plain_text(hash[:title], "#{path}.title", true, 100)
      validate_for_text_objects(hash[:text], "#{path}.text", true, 300)
      validate_for_plain_text(hash[:confirm], "#{path}.confirm", true, 30)
      validate_for_plain_text(hash[:deny], "#{path}.deny", true, 30)

      validate_for(hash[:style], "#{path}.style", String, false, only: %w(danger primary))
    end

    def validate_option(hash, path, options)
      if options[:actoin_type] == "overflow"
        validate_for_properties(hash, path, OPTION_OF_OVERFLOW_PROPERTIES)
      else
        validate_for_properties(hash, path, OPTION_PROPERTIES)
      end

      if options[:text_type] == :text_objects
        validate_for_text_objects(hash[:text], "#{path}.text", true, 75)
      else
        validate_for_plain_text(hash[:text], "#{path}.text", true, 75)
      end
      validate_for(hash[:value], "#{path}.value", String, true, max: 75)
      validate_for_plain_text(hash[:description], "#{path}.description", false, 75)
      validate_for_plain_text(hash[:url], "#{path}.url", false, 3000)
    end

    def validate_option_group(hash, path, options = nil)
      validate_for_properties(hash, path, OPTION_GROUP_PROPERTIES)

      validate_for_plain_text(hash[:label], "#{path}.label", true, 75)
      validate_for(hash[:options], "#{path}.options", Array, true, max: 100)
      Array(hash[:options]).each_with_index do |v, i|
        validate_option(v, "#{path}.options[#{i}]")
      end
    end

    def validate_dispatch_action_config(hash, path, options = nil)
      validate_for_properties(hash, path, DISPATCH_ACTION_CONFIGURATION_PROPERTIES)
      validate_for(hash[:trigger_actions_on], "#{path}.trigger_actions_on", :array_of_string, false, only: %w(on_enter_pressed on_character_entered))
    end

    def validate_filter(hash, path, options = nil)
      validate_for_properties(hash, path, FILTER_PROPERTIES)
      validate_for(hash[:include], "#{path}.include", Array, false, only: %w(im mpim private public))
      if hash[:include].is_a?(Array) && hash[:include].size == 0
        add_error("#{path}.include", :empty)
      end

      validate_for(hash[:exclude_external_shared_channels], "#{path}.exclude_external_shared_channels", :bool, false)
      validate_for(hash[:exclude_bot_users], "#{path}.exclude_bot_users", :bool, false)
    end
  end
end
