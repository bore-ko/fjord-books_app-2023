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
    create_date = Date.new(2023, 12, 13)
    other_date = Date.new(2023, 12, 14)
    user = User.create!(email: 'bar@exsample.com', password: 'password')
    report = Report.create!(user:, title: 'title', content: 'content', created_at: create_date)
    assert_equal create_date.strftime('%Y-%m-%d'), report.created_on.strftime('%Y-%m-%d')
    assert_not_equal other_date.strftime('%Y-%m-%d-%a'), report.created_on.strftime('%Y-%m-%d-%a')
  end
end
