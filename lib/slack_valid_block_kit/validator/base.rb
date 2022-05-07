module SlackValidBlockKit::Validator
  module Base
    MULTI_SELECT_TYPES = %w(multi_static_select multi_external_select multi_users_select multi_conversations_select multi_channels_select)
    SELECT_TYPES = %w(static_select external_select users_select conversations_select channels_select)
    ACTION_ELEMENT_TYPES = %w(button overflow datepicker radio_buttons checkboxes timepicker) + SELECT_TYPES + MULTI_SELECT_TYPES
    INPUT_ELEMENT_TYPES = %w(checkboxes datepicker plain_text_input radio_buttons timepicker) + SELECT_TYPES + MULTI_SELECT_TYPES
    ALL_ELEMENT_TYPES = %w(button overflow datepicker radio_buttons checkboxes timepicker plain_text_input image) + SELECT_TYPES + MULTI_SELECT_TYPES
    LAYOUT_BLOCKS_FOR_MODAL = %w(actions context divider header image input section)
    LAYOUT_BLOCKS_FOR_HOME = LAYOUT_BLOCKS_FOR_MODAL
    LAYOUT_BLOCKS_FOR_MESSAGE = LAYOUT_BLOCKS_FOR_MODAL + %w(file)

    BLOCK_KIT_GROUPS = {
      action_elements: ACTION_ELEMENT_TYPES,
      input_elements: INPUT_ELEMENT_TYPES,
      all_element_types: ALL_ELEMENT_TYPES,
      plain_text: ["plain_text"],
      text_objects: %w(plain_text mrkdwn),

      image_or_text: %(plain_text mrkdwn image),

      layout_blocks_for_modal: LAYOUT_BLOCKS_FOR_MODAL,
      layout_blocks_for_home: LAYOUT_BLOCKS_FOR_HOME,
      layout_blocks_for_message: LAYOUT_BLOCKS_FOR_MESSAGE,

      modal: ["modal"],
      top: %w(modal home blocks)
    }

    def validate(obj, path, types, options = nil)
      return if obj.nil?
      type = obj[:type]
      return unless validate_for_types(type, "#{path}.type", types)
      self.send("validate_#{type}", obj, "#{path}(#{type})", options)
      errors_by_path
    end

    def validate_for(obj, path, clazz_type, required,  only: nil, max: nil, min: nil)
      if obj.nil?
        add_error(path, :required) if required
        return
      end

      if blank?(obj)
        add_error(path, :no_item)
        return
      end

      if clazz_type == Array
        if !obj.is_a?(Array)
          add_error(path, :clazz_type, Array)
        end
      elsif clazz_type == :bool
        if !obj.is_a?(TrueClass) && !obj.is_a?(FalseClass)
          add_error(path, :clazz_type, :bool)
        end
      elsif clazz_type == :array_of_string
        if !obj.is_a?(Array) || obj.reject { |v| v.class == String }.size > 0
          add_error(path, :clazz_type, :array_of_string)
        end
      else
        if !obj.is_a?(clazz_type)
          add_error(path, :clazz_type, clazz_type)
        end
      end

      if !only.nil?
        if obj.is_a?(Array)
          add_error(path, :only, only) if (obj - only).size > 0
        else
          add_error(path, :only, only) if !only.include?(obj)
        end
      end

      if !max.nil?
        if obj.is_a?(Numeric)
          add_error(path, :max, max) if obj > max
        else
          add_error(path, :max_size, max) if obj.size > max
        end
      end

      if !min.nil?
        if obj.is_a?(Numeric)
          add_error(path, :min, min) if obj < min
        else
          add_error(path, :min_size, min) if obj.size < min
        end
      end
    end

    def blank?(v)
      v.nil? || (countable?(v) ? v.size.zero? : false)
    end

    def present?(v)
      v.respond_to?(:size) ? !v.size.zero? : !v.nil?
    end

    def countable?(v)
      v.is_a?(Array) || v.is_a?(Hash) || v.is_a?(String)
    end

    def validate_for_types(type, path, types)
      if type.nil?
        add_error(path, :required)
        return false
      end

      return true if types.nil?

      if !BLOCK_KIT_GROUPS[types].include?(type.to_s)
        add_error(path, :invalid_type)
        return false
      end
      true
    end

    def validate_for_properties(obj, path, properties)
      other_properties = obj.keys - properties
      if present?(other_properties)
        add_error(path, :invalid_properties, other_properties)
        false
      else
        true
      end
    end

    def validate_for_block_id(block_id, path)
      validate_for(block_id, path, String, false, max: 255)
      unless block_id.nil?
        path_by_block_id[block_id] ||= []
        path_by_block_id[block_id] << path
      end
    end

    def validate_for_action_id(action_id, path)
      validate_for(action_id, path, String, true, max: 255)
      unless action_id.nil?
        path_by_action_id[action_id] ||= []
        path_by_action_id[action_id] << path
      end
    end

    def validate_for_plain_text(obj, path, required, size)
      validate_for(obj, path, Hash, required)
      validate(obj, path, :plain_text, { text_size: size })
    end

    def validate_for_text_objects(obj, path, required, size)
      validate_for(obj, path, Hash, required)
      validate(obj, path, :text_objects, { text_size: size }) if present?(obj)
    end

    def validate_for_focus_on_load(obj, path)
      validate_for(obj, path, :bool, false)
      focus_on_load_by_path[path] = true if obj
    end

    private def add_error(path, kind, option = nil)
      errors_by_path[path] ||= []
      errors_by_path[path] << ::SlackValidBlockKit::Validator::Error.new(kind, option)
    end
  end
end
