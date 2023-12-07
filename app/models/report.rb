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

  before_save -> { destroy_mentions(id) }
  after_save -> { save_mentions(content) }

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def destroy_mentions(id)
    mentioning_reports = Mention.where(mentioning_report_id: id)
    mentioning_reports.each(&:destroy!) if mentioning_reports.present?
  end

  def save_mentions(content)
    mentioned_report_ids = content.scan(%r{http://localhost:3000/reports/(\d+)})
    mentioned_report_ids.flatten.each do |report_id|
      mention = Mention.new(mentioning_report_id: id, mentioned_report_id: report_id)
      mention.save!
    end
  end
end
