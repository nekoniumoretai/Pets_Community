class User::ReportsController < ApplicationController
  before_action :authenticate_user!

  def new
    @report = Report.new
    render layout: false
  end

  def create
    # ユーザーが報告する対象の種類とIDを取得
    content_type = params[:report][:content_type]
    content_id = params[:report][:content_id]

    # 対象のコンテンツをデータベースから取得
    @content = content_type.constantize.find(content_id)

    # 対象のコンテンツが存在する場合
    if @content
      # 新しい報告オブジェクトを作成
      @report = Report.new(report_params)

      # 報告者と報告対象を設定
      @report.reporter = current_user
      @report.reported = @content.user

      # 報告をデータベースに保存
      if @report.save
        respond_to do |format|
          format.js { render "create_success" } # 成功時のレスポンスを返す
        end
      else
        respond_to do |format|
          format.js { render "create_failure" } # 失敗時のレスポンスを返す
        end
      end
    end

  rescue ActiveRecord::NotNullViolation => e
    # NOT NULL 制約違反が発生した場合もエラー処理
    respond_to do |format|
      format.js { render "create_failure", status: :unprocessable_entity } # エラーレスポンスを返す
    end
  end


  private
    # コンテンツをデータベースから取得するメソッド
    def find_content(content_type, content_id)
      content_class = content_type.classify.constantize
      content_class.find_by(id: content_id)
    end

    # 報告のパラメーターを安全に受け取るためのメソッド
    def report_params
      params.require(:report).permit(:content_type, :content_id, :reason)
    end
end
