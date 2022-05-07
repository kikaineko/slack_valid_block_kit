require "slack_valid_block_kit/version"

require "slack_valid_block_kit/config"

require "slack_valid_block_kit/validator"
require "slack_valid_block_kit/builder"

module SlackValidBlockKit
  def self.build(validate: nil)
    hash = yield(::SlackValidBlockKit::Builder::Runner.new)
    raise "SlackValidBlockKit.build must return a Hash object." unless hash.is_a?(Hash)

    if validate.nil?
      if SlackValidBlockKit::Config.skip_validation.nil? || SlackValidBlockKit::Config.skip_validation
        validate!(hash)
      end
    elsif validate
      validate!(hash)
    end
    hash
  end

  def self.blocks(validate: nil)
    blocks = yield(::SlackValidBlockKit::Builder::Runner.new)
    raise "SlackValidBlockKit.blocks must return an Array object." unless blocks.is_a?(Array)

    if validate.nil?
      if SlackValidBlockKit::Config.skip_validation.nil? || SlackValidBlockKit::Config.skip_validation
        validate_blocks!(blocks)
      end
    elsif validate
      validate_blocks!(blocks)
    end
    blocks
  end

  def self.validate(obj)
    this = ::SlackValidBlockKit::Validator::Runner.new
    this.validate(obj, "root", :top)
    this.validate_block_id
    this.validate_action_id
    this.validate_focus_on_load
    this.errors_by_path
  end

  def self.validate!(obj)
    errors_by_path = validate(obj)
    if errors_by_path.size > 0
      raise "invalid json.\n#{::SlackValidBlockKit::Validator::Error.messages(errors_by_path).join("\n")}"
    end
    true
  end

  def self.validate_blocks(obj)
    if obj.is_a?(Array)
      obj = { blocks: obj }
    end
    this = ::SlackValidBlockKit::Validator::Runner.new
    this.validate_blocks(obj, "root", :top)
    this.validate_block_id
    this.validate_action_id
    this.validate_focus_on_load
    this.errors_by_path
  end

  def self.validate_blocks!(blocks)
    errors_by_path = validate_blocks(blocks)
    if errors_by_path.size > 0
      raise "invalid json.\n#{::SlackValidBlockKit::Validator::Error.messages(errors_by_path).join("\n")}"
    end
    true
  end
end
