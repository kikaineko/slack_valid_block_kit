module SlackValidBlockKit::Validator
  module Element
    BUTTON_PROPERTIES = %i(type text action_id url value style confirm accessibility_label)
    CHECKBOXES_PROPERTIES = %i(type action_id options initial_options confirm focus_on_load)
    DATEPICKER_PROPERTIES = %i(type action_id placeholder initial_date confirm focus_on_load)
    IMAGE_PROPERTIES = %i(type image_url alt_text)

    OVERFLOW_PROPERTIES = %i(type action_id options confirm)
    PLAIN_TEXT_INPUT_PROPERTIES = %i(type action_id placeholder initial_value multiline min_length max_length dispatch_action_config focus_on_load)
    RADIO_BUTTONS_PROPERTIES = %i(type action_id options initial_option confirm focus_on_load)
    TIMEPICKER_PROPERTIES = %i(type action_id placeholder initial_time confirm focus_on_load)

    def validate_button(hash, path, options = nil)
      validate_for_properties(hash, path, BUTTON_PROPERTIES)
      validate_for(hash[:type], "#{path}.type", String, true, only: ["button"])
      validate_for_plain_text(hash[:text], "#{path}.text", true, 75)
      validate_for_action_id(hash[:action_id], "#{path}.action_id")
      validate_for(hash[:url], "#{path}.url", String, false, max: 3000)
      validate_for(hash[:value], "#{path}.value", String, false, max: 2000)
      validate_for(hash[:style], "#{path}.style", String, false, only: %w(primary danger))
      validate_for(hash[:confirm], "#{path}.confirm", Hash, false)
      validate_confirmation(hash[:confirm], "#{path}.confirm") unless hash[:confirm].nil?
      validate_for(hash[:accessibility_label], "#{path}.accessibility_label", String, false, max: 75)
    end

    def validate_checkboxes(hash, path, options = nil)
      validate_for_properties(hash, path, CHECKBOXES_PROPERTIES)
      validate_for(hash[:type], "#{path}.type", String, true, only: ["checkboxes"])

      validate_for(hash[:options], "#{path}.options", Array, true, max: 10)
      options = Array(hash[:options])
      options.each_with_index do |e, i|
        validate_option(e, "#{path}.options[#{i}]", { text_type: :text_objects })
      end
      validate_for(hash[:initial_options], "#{path}.initial_options", Array, false, max: options.size, only: options)

      validate_common_for_input(hash, path, options)
    end

    def validate_datepicker(hash, path, options = nil)
      validate_for_properties(hash, path, DATEPICKER_PROPERTIES)
      validate_for(hash[:type], "#{path}.type", String, true, only: ["datepicker"])

      validate_for_plain_text(hash[:placeholder], "#{path}.placeholder", false, 150)
      validate_for(hash[:initial_date], "#{path}.initial_date", String, false)

      if hash[:initial_date].is_a?(String) && !(hash[:initial_date] =~ /^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2]\d|3[0-1])$/)
        add_error("#{path}.initial_date", :invalid_format)
      end

      validate_common_for_input(hash, path, options)
    end

    def validate_image(hash, path, options = nil)
      validate_for_properties(hash, path, IMAGE_PROPERTIES)
      validate_for(hash[:type], "#{path}.type", String, true, only: ["image"])

      validate_for(hash[:image_url], "#{path}.image_url", String, true)
      validate_for(hash[:alt_text], "#{path}.alt_text", String, true)
    end

    def validate_overflow(hash, path, options = nil)
      validate_for_properties(hash, path, OVERFLOW_PROPERTIES)
      validate_for(hash[:type], "#{path}.type", String, true, only: ["overflow"])
      validate_for_action_id(hash[:action_id], "#{path}.action_id")

      validate_for(hash[:options], "#{path}.options", Array, true, max: 5, min: 2)
      options = Array(hash[:options])
      options.each_with_index do |e, i|
        validate_option(e, "#{path}.options[#{i}]", { text_type: :text_objects })
      end

      validate_for(hash[:confirm], "#{path}.confirm", Hash, false)
      validate_confirmation(hash[:confirm], "#{path}.confirm") unless hash[:confirm].nil?
    end

    def validate_plain_text_input(hash, path, options = nil)
      validate_for_properties(hash, path, PLAIN_TEXT_INPUT_PROPERTIES)
      validate_for(hash[:type], "#{path}.type", String, true, only: ["plain_text_input"])
      validate_for_action_id(hash[:action_id], "#{path}.action_id")
      validate_for_plain_text(hash[:placeholder], "#{path}.placeholder", false, 150)
      validate_for(hash[:initial_value], "#{path}.initial_value", String, false)
      validate_for(hash[:multiline], "#{path}.multiline", :bool, false)
      validate_for(hash[:min_length], "#{path}.min_length", Integer, false, max: 3000)
      validate_for(hash[:max_length], "#{path}.max_length", Integer, false, max: 3000)

      validate_for(hash[:dispatch_action_config], "#{path}.dispatch_action_config", Hash, false)
      validate_dispatch_action_config(hash[:dispatch_action_config], "#{path}.dispatch_action_config") unless hash[:dispatch_action_config].nil?

      validate_for_focus_on_load(hash[:focus_on_load], "#{path}.focus_on_load")
    end

    def validate_radio_buttons(hash, path, options = nil)
      validate_for_properties(hash, path, RADIO_BUTTONS_PROPERTIES)
      validate_for(hash[:type], "#{path}.type", String, true, only: ["radio_buttons"])

      validate_for(hash[:options], "#{path}.options", Array, true, max: 10)
      options = Array(hash[:options])
      options.each_with_index do |e, i|
        validate_option(e, "#{path}.options[#{i}]", { text_type: :text_objects })
      end
      validate_for(hash[:initial_options], "#{path}.initial_options", Array, false, max: options.size, only: options)

      validate_common_for_input(hash, path, options)
    end

    def validate_timepicker(hash, path, options = nil)
      validate_for_properties(hash, path, TIMEPICKER_PROPERTIES)
      validate_for(hash[:type], "#{path}.type", String, true, only: ["timepicker"])

      validate_for_plain_text(hash[:placeholder], "#{path}.placeholder", false, 150)
      validate_for(hash[:initial_time], "#{path}.initial_time", String, false)
      if hash[:initial_time].is_a?(String) && !(hash[:initial_time] =~ /^(0\d|1[0-2])-[0-5]\d$/)
        add_error("#{path}.initial_time", :invalid_format)
      end

      validate_common_for_input(hash, path, options)
    end

    private def validate_common_for_input(hash, path, options = nil)
      validate_for_action_id(hash[:action_id], "#{path}.action_id")

      validate_for(hash[:confirm], "#{path}.confirm", Hash, false)
      validate_confirmation(hash[:confirm], "#{path}.confirm") unless hash[:confirm].nil?
      validate_for_focus_on_load(hash[:focus_on_load], "#{path}.focus_on_load")
    end
  end
end
