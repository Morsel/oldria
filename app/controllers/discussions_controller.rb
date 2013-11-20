class DiscussionsController < ApplicationController
  before_filter :require_user

  def index
    @discussions = current_user.discussions.all(:order => 'discussions.created_at DESC')
  end

  def show
    load_and_authorize_discussion
    load_comments
    build_comment
  end

  def new
    @discussion = current_user.posted_discussions.build(:user_ids => [current_user.id])
    @discussion.attachments.build
    if params[:restaurant_id]
      @restaurant = Restaurant.find(params[:restaurant_id])
      @discussion.users << @restaurant.employees
    end
  end

  def create
    @discussion = current_user.posted_discussions.build(params[:discussion])

    # for cross-restaurant conversations, form submitted from conversations/new
    if params[:search]
      search_setup(@discussion)
      save_search
      @discussion.users << @search.relation.map(&:employee)
    end

    if @discussion.save
      redirect_to @discussion
    else
      render :new
    end
  end

  ##
  # PUT /discussions/1/read
  # This is meant to be called via AJAX
  def read
    @discussion = current_user.discussions.find(params[:id])
    @discussion && @discussion.read_by!(current_user)
    @discussion.comments.each do |comment|
      comment.read_by!(current_user) unless comment.read_by?(current_user)
    end
    render :nothing => true
  end

  private

  def load_and_authorize_discussion
    @discussion = Discussion.find(params[:id], :include => :attachments)
    unauthorized! if cannot? :read, @discussion
  end

  def load_comments
    @comments = @discussion.posted_comments
  end

  def build_comment
    @comment = @discussion.comments.build
    @comment.user = current_user
    @comment.attachments.build
    @comment_resource = [@discussion, @comment]
  end
end
