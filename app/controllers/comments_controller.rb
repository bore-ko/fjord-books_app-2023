class CommentsController < ApplicationController
  before_action :set_report
  # before_action :set_comment

  # def index
  #   @comments = @report.comments
  # end
  # def new
  #   @comment = @report.comments.build
  # end
  #
  # def edit
  # end


  def show
    @comment = @report.comments.new
  end
  
  def create
    @comment = @report.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to @report, notice: t('controllers.common.notice_create', name: Comment.model_name.human)
    else
      render :show
    end
  end

  def destroy
    # @report.comments.destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to @report, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
  end

  private

  def set_report
    @report = Report.find(params[:report_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
