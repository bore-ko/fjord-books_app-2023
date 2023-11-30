# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :active_mentions, class_name: 'Mention', foreign_key: 'mentioning_report_id', dependent: :destroy, inverse_of: :mentioning_report
  has_many :mentioning_reports, through: :active_mentions, source: :mentioned_report
  has_many :passive_mentions, class_name: 'Mention', foreign_key: 'mentioned_report_id', dependent: :destroy, inverse_of: :mentioning_report
  has_many :mentioned_reports, through: :passive_mentions, source: :mentioning_report

  validates :title, presence: true
  validates :content, presence: true

  after_save -> { saved_mentions(content) }

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def created_report_and_mentions(report)
    ActiveRecord::Base.transaction do
      report.save!
    end
  end

  def updated_report_and_mentions(report, report_params)
    ActiveRecord::Base.transaction do
      mentioning_reports = Mention.where(mentioning_report_id: report.id)
      mentioning_reports.each(&:destroy!) if mentioning_reports.present?
      report.update!(report_params)
    end
  end

  def saved_mentions(content)
    mentioned_report_ids = content.scan(%r{http://localhost:3000/reports/(\d+)})
    if mentioned_report_ids.present? # rubocop:disable Style/GuardClause
      mentioned_report_ids.flatten.each do |report_id|
        mention = Mention.new(mentioning_report_id: id, mentioned_report_id: report_id)
        mention.save!
      end
    end
  end
end
