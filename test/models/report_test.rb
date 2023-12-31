# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test '#editable?' do
    user = User.create!(email: 'foo@exsample.com', password: 'password')
    other = User.create!(email: 'other@example.com', password: 'password')
    report = Report.create!(user:, title: 'title', content: 'content')
    assert report.editable?(user)
    assert_not report.editable?(other)
  end

  test '#created_on' do
    user = User.create!(email: 'bar@exsample.com', password: 'password')
    report = Report.create!(user:, title: 'title', content: 'content')
    assert_equal Date.current, report.created_on
    assert_not_equal Date.new(2023, 12, 1), report.created_on
  end
end
