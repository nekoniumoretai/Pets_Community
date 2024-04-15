class Admin::SearchesController < ApplicationController
  before_action :authenticate_admin!

  def search
    @model = params[:model]
    @content = params[:content]
    @method = params[:method]

    case @model
    when "user"
      @records = User.search_for(@content, @method)
    when "post"
      @records = Post.search_for(@content, @method)
    when "post_comment"
      @records = PostComment.search_for(@content, @method)
    end
  end
end
