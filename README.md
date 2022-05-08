# SlackValidBlockKit

A tool for building Slack Block Kit with validation.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'slack_valid_block_kit'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install slack_valid_block_kit

## Usage

- [surfaces.rb](https://github.com/kikaineko/slack_valid_block_kit/blob/main/lib/slack_valid_block_kit/builder/surfaces.rb) contains the [View objects](https://api.slack.com/reference/surfaces/views)
- [layouts.rb](https://github.com/kikaineko/slack_valid_block_kit/blob/main/lib/slack_valid_block_kit/builder/layouts.rb) contains the [Layout blocks](https://api.slack.com/reference/messaging/blocks)
- [elements.rb](https://github.com/kikaineko/slack_valid_block_kit/blob/main/lib/slack_valid_block_kit/builder/elements.rb) contains the [Block elements](https://api.slack.com/reference/messaging/block-elements)
- [compositions.rb](https://github.com/kikaineko/slack_valid_block_kit/blob/main/lib/slack_valid_block_kit/builder/compositions.rb) contains the [Message composition objects](https://api.slack.com/reference/messaging/composition-objects)


You can build views by `SlackValidBlockKit.build` or `SlackValidBlockKit.blocks`.

Both methods run validation your views automatically.

```ruby
# Build modal with validation
modal = SlackValidBlockKit.build do |b|
  b.modal(...)
end

# Build blocks with validation
blocks = SlackValidBlockKit.blocks do |b|
  [...]
end
```

If you want to skip validations, you write as follows.

```ruby
# Build modal without validation
modal = SlackValidBlockKit.build(validate: false) do |b|
  b.modal(...)
end

# Build blocks without validation
blocks = SlackValidBlockKit.blocks(validate: false) do |b|
  [...]
end
```

or you can set to skip validations as config
```ruby
SlackValidBlockKit::Config.skip_validation = true
```

For example, when you ride on Rails, you can set in `config/initializers/slack_valid_block_kit.rb`.

```ruby
SlackValidBlockKit::Config.skip_validation = Rails.env.production?
```

You can just use validations.

```ruby
modal = ... # create a modal hash without SlackValidBlockKit

SlackValidBlockKit.validate!(modal) # raise an exception with the invalid input


blocks = ... # create a blocks array without SlackValidBlockKit

SlackValidBlockKit.validate_blocks!(blocks) # raise an exception with the invalid input
```

## Examples

Modal example with validation

```ruby
require 'slack_valid_block_kit'
require 'json'

modal = SlackValidBlockKit.build do |b|
  b.modal(
    title: b.plain_text(text: "Modal title"),
    blocks: [
      b.section(
        text: b.mrkdwn(text: "It's Block Kit...but _in a modal_"),
        block_id: "section1",
        accessory: b.button(
          text: b.plain_text(text: "Click me"),
          action_id: "button_abc",
          value: "Button value",
          style: "danger"
        )
      )
    ],
    close: b.plain_text(text: "Cancel"),
    submit: b.plain_text(text: "Save"),
    private_metadata: "Shhhhhhhh",
    callback_id: "view_identifier_12"
  )
end

puts modal.to_json
```

You will get this.
![modal example](https://user-images.githubusercontent.com/724270/167277875-c1e6627f-e59d-485f-b574-d5797c954f36.png)

You can get a just `blocks` array (with validation).

```ruby
require 'slack_valid_block_kit'
require 'json'

blocks = SlackValidBlockKit.blocks do |b|
  [
    b.divider,
    b.section(
      text: b.mrkdwn(text: "*<fakeLink.toHotelPage.com|Windsor Court Hotel>*\n★★★★★\n$340 per night\nRated: 9.4 - Excellent"),
      accessory: b.image(
        image_url: "https://api.slack.com/img/blocks/bkb_template_images/tripAgent_1.png",
        alt_text: "Windsor Court Hotel thumbnail"
      )
    ),
    b.context(
      elements: [
        b.image(
          image_url: "https://api.slack.com/img/blocks/bkb_template_images/tripAgentLocationMarker.png",
          alt_text: "Location Pin Icon"
        ),
        b.plain_text(text: "Location: Central Business District", emoji: true)
      ]
    )
  ]
end

puts blocks.to_json
```

You will get this.
![message example](https://user-images.githubusercontent.com/724270/167278001-2235d8b6-9d4b-47dd-b5ba-13880383f89b.png)

##

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/slack_valid_block_kit. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SlackValidBlockKit project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/slack_valid_block_kit/blob/master/CODE_OF_CONDUCT.md).
