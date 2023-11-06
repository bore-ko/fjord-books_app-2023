# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[show edit update destroy]
  def index
    @reports = Report.order(:id).page(params[:page]).per(5)
  end

  def new
    @report = Report.new
  end

  def show
    @comments = @report.comments.order(:id)
    @comment = Comment.new
  end

  def edit; end

  def create
    @report = current_user.reports.new(report_params)
    if @report.save
      redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
    else
      render :new
    end
  end

  def update
    @report = current_user.reports.find(params[:id])
    if @report.update(report_params)
      redirect_to reports_path, notice: t('controllers.common.notice_update', name: Report.model_name.human)
    else
      render :edit
    end
  end

  def destroy
    @report = current_user.reports.find(params[:id])
    @report.destroy
    redirect_to reports_path, notice: t('controllers.common.notice_destroy', name: Report.model_name.human)
  end

  private

  def set_report
    @report = Report.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:title, :description)
  end
end
