module SlackValidBlockKit
  module Builder
    module Layouts
      def actions(elements:, block_id: nil)
        hash = { type: 'actions' }
        hash[:elements] = elements
        hash[:block_id] = block_id.is_a?(Symbol) ? block_id.to_s : block_id unless block_id.nil?
        hash
      end

      def context(elements:, block_id: nil)
        hash = { type: 'context' }
        hash[:elements] = elements
        hash[:block_id] = block_id.is_a?(Symbol) ? block_id.to_s : block_id unless block_id.nil?
        hash
      end

      def divider(block_id: nil)
        hash = { type: 'divider' }
        hash[:block_id] = block_id.is_a?(Symbol) ? block_id.to_s : block_id unless block_id.nil?
        hash
      end

      def file(elements:, source:, block_id: nil)
        hash = { type: 'file' }
        hash[:elements] = elements
        hash[:source] = source
        hash[:block_id] = block_id.is_a?(Symbol) ? block_id.to_s : block_id unless block_id.nil?
        hash
      end

      def header(text:, block_id: nil)
        hash = { type: 'header' }
        hash[:text] = text
        hash[:block_id] = block_id.is_a?(Symbol) ? block_id.to_s : block_id unless block_id.nil?
        hash
      end

      def image(image_url:, alt_text:, title: nil, block_id: nil)
        hash = { type: 'image' }
        hash[:image_url] = image_url
        hash[:alt_text] = alt_text
        hash[:title] = title unless title.nil?
        hash[:block_id] = block_id.is_a?(Symbol) ? block_id.to_s : block_id unless block_id.nil?
        hash
      end

      def input(label:, element:, dispatch_action: nil, block_id: nil, hint: nil, optional: nil)
        hash = { type: 'input' }
        hash[:label] = label
        hash[:element] = element
        hash[:dispatch_action] = dispatch_action unless dispatch_action.nil?
        hash[:block_id] = block_id.is_a?(Symbol) ? block_id.to_s : block_id unless block_id.nil?
        hash[:hint] = hint unless hint.nil?
        hash[:optional] = optional unless optional.nil?
        hash
      end

      def section(text: nil, block_id: nil, fields: nil, accessory: nil)
        hash = { type: 'section' }
        hash[:text] = text unless text.nil?
        hash[:block_id] = block_id.is_a?(Symbol) ? block_id.to_s : block_id unless block_id.nil?
        hash[:fields] = fields unless fields.nil?
        hash[:accessory] = accessory unless accessory.nil?
        hash
      end
    end
  end
end
