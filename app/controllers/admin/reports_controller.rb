class Admin::ReportsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @reports = Report.order("created_at desc").page(params[:page]).per(15)
  end

  def destroy
    @report = Report.find(params[:id])
    @report.delete
    redirect_to admin_reports_path, notice: "対応完了しました"
  end

  private

  def report_params
    params.require(:report).permit(:is_checked, :reason, :content, :content_type)
  end

end
