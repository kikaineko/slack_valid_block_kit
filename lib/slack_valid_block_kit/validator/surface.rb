module SlackValidBlockKit::Validator
  module Surface
    MODAL_PROPERTIES = %i(type title blocks close submit private_metadata callback_id clear_on_close notify_on_close external_id)
    HOME_PROPERTIES = %i(type blocks private_metadata callback_id external_id)

    def validate_modal(hash, path, options = nil)
      validate_for_properties(hash, path, MODAL_PROPERTIES)
      validate_for(hash[:type], "#{path}.type", String, true, only: ["modal"])
      validate_for_plain_text(hash[:title], "#{path}.title", true, 24)

      validate_for(hash[:blocks], "#{path}.blocks", Array, true, max: 100)
      Array(hash[:blocks]).each_with_index do |e, i|
        validate(e, "#{path}.blocks[#{i}]", :layout_blocks_for_modal)
      end

      validate_for_plain_text(hash[:close], "#{path}.close", false, 24)
      validate_for_plain_text(hash[:submit], "#{path}.submit", false, 24)

      if hash[:submit].nil? && Array(hash[:blocks]).select { |b| b[:type] == "input" }.size > 0
        add_error(path, :require_submit_with_input)
      end

      validate_for(hash[:private_metadata], "#{path}.private_metadata", String, false, max: 3000)
      validate_for(hash[:callback_id], "#{path}.callback_id", String, false, max: 255)
      validate_for(hash[:clear_on_close], "#{path}.clear_on_close", :bool, false)
      validate_for(hash[:notify_on_close], "#{path}.notify_on_close", :bool, false)
      validate_for(hash[:external_id], "#{path}.external_id", String, false)
    end

    def validate_home(hash, path, options = nil)
      validate_for_properties(hash, path, HOME_PROPERTIES)
      validate_for(hash[:type], "#{path}.type", String, true, only: ["home"])
      validate_for_plain_text(hash[:title], "#{path}.title", true, 24)

      validate_for(hash[:blocks], "#{path}.blocks", Array, true, max: 100)
      Array(hash[:blocks]).each_with_index do |e, i|
        validate(e, "#{path}.blocks[#{i}]", :layout_blocks_for_home)
      end

      validate_for(hash[:private_metadata], "#{path}.private_metadata", String, false, max: 3000)
      validate_for(hash[:callback_id], "#{path}.callback_id", String, false, max: 255)
      validate_for(hash[:external_id], "#{path}.external_id", String, false)
    end

    def validate_blocks(hash, path, options = nil)
      validate_for(hash[:blocks], "#{path}.blocks", Array, true)
      Array(hash[:blocks]).each_with_index do |e, i|
        validate(e, "#{path}.blocks[#{i}]", :layout_blocks_for_message)
      end
    end
  end
end
