module SlackValidBlockKit
  module Builder
    module Compositions
      def plain_text(text:, emoji: nil)
        hash = { type: 'plain_text' }
        hash[:text] = text
        hash[:emoji] = emoji unless emoji.nil?
        hash
      end

      def mrkdwn(text:, verbatim: nil)
        hash = { type: 'mrkdwn' }
        hash[:text] = text
        hash[:verbatim] = verbatim unless verbatim.nil?
        hash
      end

      def confirmation(title:, text:, confirm:, deny:, style: nil)
        hash = {}
        hash[:title] = title
        hash[:text] = text
        hash[:confirm] = confirm
        hash[:deny] = deny
        hash[:style] = style unless style.nil?
        hash
      end

      def option(text:, value:, description: nil, url: nil)
        hash = {}
        hash[:text] = text
        hash[:value] = value
        hash[:description] = description unless description.nil?
        hash[:url] = url unless url.nil?
        hash
      end

      def option_group(label:, options:)
        hash = {}
        hash[:label] = label
        hash[:options] = options
        hash
      end

      def dispatch_action_configuration(trigger_actions_on: nil)
        hash = {}
        hash[:trigger_actions_on] = trigger_actions_on unless trigger_actions_on.nil?
        hash
      end

      def filter(include: nil, exclude_external_shared_channels: nil, exclude_bot_users: nil)
        hash = {}
        hash[:include] = include unless include.nil?
        hash[:exclude_external_shared_channels] = exclude_external_shared_channels unless exclude_external_shared_channels.nil?
        hash[:exclude_bot_users] = exclude_bot_users unless exclude_bot_users.nil?
        hash
      end
    end
  end
end
