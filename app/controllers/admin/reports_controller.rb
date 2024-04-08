class Admin::ReportsController < ApplicationController
  before_action :authenticate_admin!
  before_action :get_report, only: [:show, :update]

  def index
    @reports = Report.order("created_at desc").page(params[:page]).per(15)
  end

  def show ;end

  def update
    if @report.update(report_params)
      flash[:notice] = "対応ステータスを更新しました。"
      redirect_to request.referer
    end
  end

  private

  def get_report
    @report = Report.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:is_checked, :reason, :content, :content_type)
  end

end
