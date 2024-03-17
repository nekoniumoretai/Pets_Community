class Notification < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  def message
    if notifiable_type === "Post"
      "フォローしている#{notifiable.user.nickname}さんが#{notifiable.title}を投稿しました"
    elsif notifiable_type === "PostComment"
      "投稿した#{notifiable.post.title}に#{notifiable.user.nickname}さんがコメントしました"
    elsif notifiable_type === "Relationship"
      "#{notifiable.follower.nickname}さんにフォローされました"
    else
      "投稿した#{notifiable.post.title}が#{notifiable.user.nickname}さんにいいねされました"
    end
  end

  def notifiable_path
    if self.notifiable_type === "Post"
      post_path(notifiable.id)
    elsif self.notifiable_type === "PostComment"
      post_path(notifiable.post_id)
    elsif self.notifiable_type === "Relationship"
      user_path(notifiable.follower_id)
    else
      root_path
    end
  end
end
