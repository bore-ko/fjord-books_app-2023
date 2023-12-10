# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test '#editable?' do
    user = User.create!(email: 'foo@exsample.com', password: 'password')
    report = Report.create!(user: :user, title: 'title', content: 'content')
    assert report.editable?(user)
  end
end
