class CommentsController < ApplicationController
  before_filter :require_user
  before_filter :find_parent, :only => [:create]

  def create
    @comment = @parent.comments.build(params[:comment])
    @comment.user_id ||= current_user.id
    @is_mediafeed = params[:mediafeed]
    success_and_archive = "Thanks: your answer has been saved. The question has been archived and can be found under the \"all\" tab."
    success = "Thanks: your answer has been saved."

    if @comment.save
      if front_burner_content
        @parent.read_by!(@comment.user)

        # if the parent is attached to a trend question, show archive message only when it's the first discussion for the user
        # why the first discussion? because we only check the first item's read/unread status in the inbox when we group these
        if @parent.is_a?(AdminDiscussion)
          @comment.user.grouped_admin_discussions[@parent.discussionable].first == @parent ?
              flash[:notice] = success_and_archive :
              flash[:notice] = success
        else
          flash[:notice] = success_and_archive
        end
      else
        flash[:notice] = success
      end
      return redirect_after_save
    else
      flash[:error] = "Your comment couldn't be saved."
      redirect_to :back
    end
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])
    @parent = @comment.commentable
    # Allow admins to edit other people's comments, otherwise we assume this is an authorized coworker
    params[:comment].merge!(:user_id => current_user.id) unless current_user.admin?

    if @comment.update_attributes(params[:comment])
      flash[:notice] = "Updated comment"
      redirect_after_save
    else
      render :action => "edit"
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:notice] = "Deleted comment"
    redirect_to front_burner_path # FIXME - admins, mediafeed, other special cases
  end

  private

  def find_parent
    if params[:media_request_discussion_id]
      @parent = MediaRequestDiscussion.find(params[:media_request_discussion_id])
    elsif params[:discussion_id]

      @parent = Discussion.find(params[:discussion_id])
    elsif params[:admin_conversation_id]
      @parent = Admin::Conversation.find(params[:admin_conversation_id])
    elsif params[:holiday_discussion_id]
      @parent = HolidayDiscussion.find(params[:holiday_discussion_id])

    elsif params[:admin_discussion_id]
      @parent = AdminDiscussion.find(params[:admin_discussion_id])
    elsif params[:solo_discussion_id]
      @parent = SoloDiscussion.find(params[:solo_discussion_id])
    elsif params[:solo_media_discussion_id]
      @parent = SoloMediaDiscussion.find(params[:solo_media_discussion_id])
    end
  end

  def front_burner_content
    @parent.is_a?(AdminDiscussion) || @parent.is_a?(SoloDiscussion) || @parent.is_a?(Admin::Conversation)
  end

  def redirect_after_save
    if mediafeed?
      redirect_to mediafeed_discussion_path(@parent.media_request, @parent.class.name.pluralize.underscore.downcase, @parent)
    elsif front_burner_content
      if current_user.admin?
        redirect_to edit_user_profile_path(:user_id => @comment.user.id, :anchor => "profile-front-burner")
      else
        redirect_to front_burner_path(:post_to_facebook => @comment.post_to_facebook, :comment_id => @comment.id)
      end
    else
      redirect_to @parent
    end
  end
end
