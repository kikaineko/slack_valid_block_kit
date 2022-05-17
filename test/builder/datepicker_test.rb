require 'test_helper'

module Builder
  class DatepickerTest < Minitest::Test
    def test_accept_date_class
      datepicker = ::SlackValidBlockKit::Builder::Runner.new.datepicker(action_id: "sample", initial_date: Date.new(2022, 1, 2))
      assert_equal "2022-01-02", datepicker[:initial_date]
    end

    def test_accept_time_class
      datepicker = ::SlackValidBlockKit::Builder::Runner.new.datepicker(action_id: "sample", initial_date: Time.new(2022, 1, 2, 22, 4, 5))
      assert_equal "2022-01-02", datepicker[:initial_date]
    end
  end
end
