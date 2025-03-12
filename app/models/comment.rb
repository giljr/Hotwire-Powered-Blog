class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :content, presence: true
  validates :user, presence: true

  # broadcasts_to :post

  after_create_commit :broadcast_post_comment_create

  private

  def broadcast_post_comment_create
    broadcast_append_to(
      post, # The stream target (the post this comment belongs to)
      partial: 'comments/comment',
      locals: { comment: self },
      target: 'comments' # The DOM element ID where the comment will be appended
    )
  end
end