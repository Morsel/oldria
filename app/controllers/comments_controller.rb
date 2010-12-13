class CommentsController < ApplicationController
  before_filter :require_user
  before_filter :find_parent, :only => [:create]

  def create
    @comment = @parent.comments.build(params[:comment])
    @comment.user_id ||= current_user.id

    if @comment.save
      if front_burner_content
        @parent.read_by!(@comment.user)
        flash[:notice] = "Successfully created comment. This message has been archived in your 'all' messages view."
      else
        flash[:notice] = "Successfully created comment."
      end
      
      redirect_to @parent
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
    if @comment.update_attributes(params[:comment].merge(:user_id => current_user.id))
      flash[:notice] = "Updated comment"
      redirect_to front_burner_content ? front_burner_path : messages_path
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:notice] = "Deleted comment"
    redirect_to front_burner_content ? front_burner_path : messages_path
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
    end
  end
  
  def front_burner_content
    @parent.is_a?(AdminDiscussion) || @parent.is_a?(SoloDiscussion) || @parent.is_a?(Admin::Conversation)
  end
end
