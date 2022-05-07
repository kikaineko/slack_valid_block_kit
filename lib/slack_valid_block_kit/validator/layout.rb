module SlackValidBlockKit::Validator
  module Layout
    ACTION_PROPERTIES = %i(type elements block_id)
    CONTEXT_PROPERTIES = %i(type elements block_id)
    DIVIDER_PROPERTIES = %i(type block_id)
    FILE_PROPERTIES = %i(type external_id source block_id)
    HEADER_PROPERTIES = %i(type text block_id)
    IMAGE_PROPERTIES = %i(type image_url alt_text title block_id)
    INPUT_PROPERTIES = %i(type label element dispatch_action block_id hint optional)
    SECTION_PROPERTIES = %i(type text block_id fields accessory)

    def validate_actions(hash, path, options = nil)
      validate_for_properties(hash, path, ACTION_PROPERTIES)
      validate_for(hash[:type], "#{path}.type", String, true, only: ["actions"])
      validate_for(hash[:elements], "#{path}.elements", Array, true, max: 25)
      Array(hash[:elements]).each_with_index do |e, i|
        validate(e, "#{path}.elements[#{i}]", :action_elements)
      end
      validate_for_block_id(hash[:block_id], "#{path}.block_id")
    end

    def validate_context(hash, path, options = nil)
      validate_for_properties(hash, path, CONTEXT_PROPERTIES)
      validate_for(hash[:type], "#{path}.type", String, true, only: ["context"])
      validate_for(hash[:elements], "#{path}.elements", Array, true, max: 10)
      Array(hash[:elements]).each_with_index do |e, i|
        validate(e, "#{path}.elements[#{i}]", :image_or_text)
      end
      validate_for_block_id(hash[:block_id], "#{path}.block_id")
    end

    def validate_divider(hash, path, options = nil)
      validate_for_properties(hash, path, DIVIDER_PROPERTIES)
      validate_for(hash[:type], "#{path}.type", String, true, only: ["divider"])
      validate_for_block_id(hash[:block_id], "#{path}.block_id")
    end

    def validate_file(hash, path, options = nil)
      validate_for_properties(hash, path, FILE_PROPERTIES)
      validate_for(hash[:type], "#{path}.type", String, true, only: ["file"])
      validate_for(hash[:external_id], "#{path}.external_id", String, true)
      validate_for(hash[:source], "#{path}.source", String, true, only: ["remote"])

      validate_for_block_id(hash[:block_id], "#{path}.block_id")
    end

    def validate_header(hash, path, options = nil)
      validate_for_properties(hash, path, HEADER_PROPERTIES)
      validate_for(hash[:type], "#{path}.type", String, true, only: ["header"])
      validate_for_plain_text(hash[:text], "#{path}.text", true, 150)
      validate_for_block_id(hash[:block_id], "#{path}.block_id")
    end

    def validate_image(hash, path, options = nil)
      validate_for_properties(hash, path, IMAGE_PROPERTIES)
      validate_for(hash[:type], "#{path}.type", String, true, only: ["image"])
      validate_for(hash[:image_url], "#{path}.image_url", String, true, max: 3000)
      validate_for(hash[:alt_text], "#{path}.alt_text", String, true, max: 2000)
      validate_for_plain_text(hash[:title], "#{path}.title", false, 2000)
      validate_for_block_id(hash[:block_id], "#{path}.block_id")
    end

    def validate_input(hash, path, options = nil)
      validate_for_properties(hash, path, INPUT_PROPERTIES)
      validate_for(hash[:type], "#{path}.type", String, true, only: ["input"])
      validate_for_plain_text(hash[:label], "#{path}.label", true, 2000)
      validate_for(hash[:element], "#{path}.element", Hash, true)
      validate(hash[:element], "#{path}.element", :input_elements)
      validate_for(hash[:dispatch_action], "#{path}.dispatch_action", :bool, false)
      validate_for_plain_text(hash[:hint], "#{path}.hint", false, 2000)
      validate_for(hash[:optional], "#{path}.optional", :bool, false)

      validate_for_block_id(hash[:block_id], "#{path}.block_id")
    end

    def validate_section(hash, path, options = nil)
      validate_for_properties(hash, path, SECTION_PROPERTIES)
      validate_for(hash[:type], "#{path}.type", String, true, only: ["section"])
      validate_for_text_objects(hash[:text], "#{path}.text", false, 3000)
      validate_for(hash[:fields], "#{path}.fields", Array, false, max: 10)
      Array(hash[:fields]).each_with_index do |e, i|
        validate_for_text_objects(e, "#{path}.fields[#{i}]", true, 2000)
      end

      if hash[:text].nil? && hash[:fields].nil?
        add_error(path, :require_text_or_fields)
      end
      validate_for(hash[:accessory], "#{path}.accessory", Hash, false)
      validate(hash[:accessory], "#{path}.accessory", :all_element_types)
    end
  end
end
