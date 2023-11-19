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

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def created_report_and_mentions(report, report_params)
    ActiveRecord::Base.transaction do
      report.save
      mentioned_report_ids = matched_report_mentions(report_params)
      saved_mention(mentioned_report_ids, report) if mentioned_report_ids.present?
    end
  end

  def updated_report_and_mentions(report, report_params)
    ActiveRecord::Base.transaction do
      report.update(report_params)
      mentioned_report_ids = matched_report_mentions(report_params)
      if mentioned_report_ids.present?
        mentioning_reports = Mention.where(mentioning_report_id: report.id)
        mentioning_reports.each(&:delete)
        saved_mention(mentioned_report_ids, report)
      end
    end
  end

  def matched_report_mentions(report_params)
    report_params[:content].scan(%r{http://localhost:3000/reports/(\d+)})
  end

  def saved_mention(mentioned_report_ids, report)
    mentioned_report_ids.flatten.each do |report_id|
      mention = Mention.new(mentioning_report_id: report.id, mentioned_report_id: report_id)
      mention.save
    end
  end
end
