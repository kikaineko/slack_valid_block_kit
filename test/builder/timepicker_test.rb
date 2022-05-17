require 'test_helper'

module Builder
  class TimepickerTest < Minitest::Test
    def test_accept_time_class
      timepicker = ::SlackValidBlockKit::Builder::Runner.new.timepicker(action_id: "sample", initial_time: Time.new(2022, 1, 2, 22, 4, 5))
      assert_equal "22:04", timepicker[:initial_time]
    end
  end
end
