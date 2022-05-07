module SlackValidBlockKit
  module Builder
    module Surfaces
      def modal(title:, blocks:, close: nil, submit: nil, private_metadata: nil, callback_id: nil, clear_on_close: nil, notify_on_close: nil, external_id: nil, submit_disabled: nil)
        hash = { type: 'modal' }
        hash[:title] = title
        hash[:blocks] = blocks
        hash[:close] = close unless close.nil?
        hash[:submit] = submit unless submit.nil?
        hash[:private_metadata] = private_metadata unless private_metadata.nil?
        hash[:callback_id] = callback_id unless callback_id.nil?
        hash[:clear_on_close] = clear_on_close unless clear_on_close.nil?
        hash[:notify_on_close] = notify_on_close unless notify_on_close.nil?
        hash[:external_id] = external_id unless external_id.nil?
        hash[:submit_disabled] = submit_disabled unless submit_disabled.nil?
        hash
      end

      def home(blocks:, private_metadata: nil, callback_id: nil, external_id: nil)
        hash = { type: 'home' }
        hash[:blocks] = blocks
        hash[:private_metadata] = private_metadata unless private_metadata.nil?
        hash[:callback_id] = callback_id unless callback_id.nil?
        hash[:external_id] = external_id unless external_id.nil?
        hash
      end

      def blocks(blocks:)
        hash = {}
        hash[:blocks] = blocks
        hash
      end
    end
  end
end
