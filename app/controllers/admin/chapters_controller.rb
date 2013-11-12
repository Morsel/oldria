class Admin::ChaptersController < Admin::AdminController

  def index
    @topics = Topic.user_topics(:order => :title)
    @chapters_by_topic = Chapter.unscoped.all(:include => :topic,
                                     :conditions => "topics.type IS NULL",
                                     :order => "topics.title ASC, chapters.position ASC").group_by(&:topic)
  end

  def create
    @chapter = Chapter.new(params[:chapter])
    if @chapter.save
      flash[:notice] = "Created new chapter named #{@chapter.title}"
      redirect_to :action => "index"
    else
      render :action => "edit"
    end
  end

  def edit
    @chapter = Chapter.find(params[:id])
  end

  def update
    @chapter = Chapter.find(params[:id])
    if @chapter.update_attributes(params[:chapter])
      flash[:notice] = "Updated chapter"
      redirect_to :action => "index"
    else
      render :action => "edit"
    end
  end

  def destroy
    @chapter = Chapter.find(params[:id])
    flash[:notice] = "Deleted chapter #{@chapter.title}"
    @chapter.destroy
    redirect_to :action => "index"
  end

  def select
    chapters = Topic.find(params[:id]).chapters
    render :update do |page|
      page.replace_html 'profile_question_chapter_id',
          '<option value=""></option>' + options_from_collection_for_select(chapters, :id, :title)
    end
  end

end
