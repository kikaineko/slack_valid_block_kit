module SlackValidBlockKit::Validator
  module Uniq
    def validate_block_id
      path_by_block_id.each do |block_id, paths|
        next if paths.size <= 1
        add_error("block_id", :not_uniq, paths)
      end
    end

    def validate_action_id
      path_by_action_id.each do |action_id, paths|
        next if paths.size <= 1
        add_error("action_id", :not_uniq, paths)
      end
    end

    def validate_focus_on_load
      if focus_on_load_by_path.keys.size > 1
        add_error("focus_on_load", :not_uniq, focus_on_load_by_path.keys)
      end
    end
  end
end
