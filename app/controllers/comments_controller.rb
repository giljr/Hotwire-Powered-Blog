class CommentsController < ApplicationController
    before_action :set_post
   
    def create
      @comment = @post.comments.build(comment_params)
      @comment.user = Current.user # Associate the comment with the current user
  
      if @comment.save
        respond_to do |format|
          format.turbo_stream # { turbo_stream.append "comments", partial: "comments/comment", locals: { comment: @comment } }
          format.html { redirect_to @post, notice: "Comment created successfully!" }
        end
      else
        redirect_to @post, alert: "Failed to create comment."
      end
    end
    private
  
    def set_post
      @post = Post.find(params[:post_id])
    end
  
    def comment_params
        params.expect(comment: [:content])
    end
  end