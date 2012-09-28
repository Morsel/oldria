class RiaWebservicesController < ApplicationController
   skip_before_filter :protect_from_forge
   before_filter :require_user,:only => [:a_la_minute_answers,:require_restaurant_employee,:menu_items,:bulk_update,:create_menu,:create_promotions,:create_photo,:show_photo,:create_comments,:get_qotds]
   before_filter :require_restaurant_employee, :only => [:a_la_minute_answers,:require_restaurant_employee,:menu_items,:bulk_update,:create_menu,:create_promotions,:create_photo,:show_photo]
   before_filter :find_activated_restaurant, :only => [:a_la_minute_answers,:require_restaurant_employee,:menu_items,:bulk_update,:create_menu,:create_promotions,:create_photo,:show_photo]
   before_filter :require_manager, :only => [:a_la_minute_answers,:require_restaurant_employee,:menu_items,:bulk_update,:create_menu,:create_promotions,:create_photo,:show_photo,:create_comments]
   before_filter :find_parent, :only => [:create_comments]

   layout false
   include ALaMinuteAnswersHelper

  def register    
    message = nil
    if params[:role] == "media"
      @user = User.build_media_from_registration(params)
      if @user.save
        @user.reset_perishable_token!
        UserMailer.deliver_signup(@user)
        status = true
      else
        status = false
      end
    elsif params[:role] == "restaurant"   
       params[:subject_matters] = eval(params[:subject_matters])
       @invitation = Invitation.build_from_registration(params)   
      if @invitation.save         
         message = "Your changes have been saved"
         status  = true
      else
         message = @invitation.errors.full_messages #.join("<br />").html_safe 
         status  = false         
      end
    elsif params[:role] == "diner"
      @subscriber = NewsletterSubscriber.build_from_registration(params)
      if @subscriber.save
        status = true
      else
        status = false
      end
    else
        status = false
        message = "Invalid request"
    end
    render :json => {:status=>status,:message=>message}
  end

  def get_join_us_value
     render :json =>{ :restaurantRole=>RestaurantRole.all,:subjectMatter=>SubjectMatter.general.all}
  end

  def create
   @user_session = UserSession.new(params)
    save_session
  end

  def save_session
    if @user_session.save
        user = @user_session.user
        unless user.push_notification_user.nil?
            @push_notification_user = user.push_notification_user
            if @push_notification_user.update_attributes(eval(params[:push_notification_user]))
              status = true
            else
              status = false    
            end
        else
              pnu = PushNotificationUser.new(eval params[:push_notification_user])
                if(pnu.save) 
                  pnu.update_attributes(:user=>current_user)
                    status = true
                else
                    status = false  
                end
         end 
        render :json => {:status=>status}
    else
       if @user_session.errors.on_base == "Your account is not confirmed"
          status = false
      elsif @user_session.errors.on(:username) || @user_session.errors.on(:password)
          status = false
      else
        status = false
      end
     render :json => {:status=>status,:message=>"Oops, you entered the wrong username or password.<br/>;"}
    end
 end

  def create_psw_rst
    @user = User.find_by_email(params[:email])
    if @user && @user.confirmed?
      @user.deliver_password_reset_instructions!
      status = true
      render :json =>{:status=>status,:message=>"Please check your email for instructions to finish resetting your password"}
    else
      status = false
       render :json =>{:status=>status,:message=>"Your account is not confirmed.<br/>Please check your email for instructions"}
    end
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    UserMailer.deliver_password_reset_instructions(self)
  end

  def require_user_local
    User.find(:first, :conditions => "username = '#{params[:username]}'")
  end

 def soap_box_index
   render :json => {:past_qotds => past_qotds, :past_trends => past_trends}
 end

def a_la_minute_answers
  question_hash = Hash.new
  @questions = ALaMinuteQuestion.restaurants
  @questions.each do |question|
    question_hash[question.id] = question.answers_for_last_seven_days(@restaurant) #question.a_la_minute_answers.all(:limit=>5)
  end
  render :json => {:questions=> @questions,:questions_answers=>question_hash }
end


  def bulk_update   
    status = false
    message = "Your changes was not saved"
    params[:a_la_minute_questions] = eval(params[:a_la_minute_questions])
    params[:a_la_minute_questions].each do |id, attributes|
      question = ALaMinuteQuestion.find(id)
      answer_id = attributes.delete(:answer_id)
      previous_answer = ALaMinuteAnswer.find(answer_id) if ALaMinuteAnswer.exists?(answer_id)
      unless attributes[:answer] == previous_answer.try(:answer)
        new_answer = @restaurant.a_la_minute_answers.create(attributes.merge(:a_la_minute_question_id => id))
      end       
      message = "Your changes have been saved."
      status =  true
    end
    render :json =>{:status=>status,:message=>message}
  end


  def menu_items
    @restaurant = Restaurant.find(params[:restaurant_id])
    @menu_items = @restaurant.menu_items.all(:order => "created_at DESC").paginate(:page => params[:page], :per_page => 10)
    @menu_item_keywords = {}
    @menu_items.each do |menu_item|
        @menu_item_keywords[menu_item.id] = menu_item.keywords
        if !menu_item.photo_file_name.nil? && !menu_item.photo_file_name.blank? 
          menu_item.photo_file_name = menu_item.photo(:thumb)
        end  
    end
        render :json => {:menu_items=>@menu_items,:keywords=>@menu_item_keywords}
  end

  def create_menu
    params[:menu_item][:otm_keyword_ids] = eval(params[:menu_item][:otm_keyword_ids])
    @menu_item = @restaurant.menu_items.build(params[:menu_item])
    @menu_item.photo_content_type = "image/#{@menu_item.photo_file_name.split(".").last}" if !@menu_item.photo_file_name.nil?
    if @menu_item.save
      render :json => {:status=>true,:message=>"Your menu item has been saved"}
    else
      render :json => {:status=>false,:message=>"Your menu item not saved"}
    end
  end

    def new_menu_item
     @categories = OtmKeyword.all(:order => "category ASC, name ASC").group_by(&:category)
     render :json =>{ :categories=>@categories}
    end

#completed
  def create_promotions   
    @promotion = @restaurant.promotions.build(params[:promotion])
    @promotion.attachment_content_type = "application/#{@promotion.attachment_file_name.split(".").last}" if !@promotion.attachment_file_name.nil?  
    if @promotion.save
      status = true
      render :json => {:status=>status,:message=>"Your promotion has been created"}
    else
       status = false
      render :json => {:status=>false,:message=>"Your promotion could not be saved. Please review the errors below"}
    end
  end 

  def get_promotion_type
    @promotion_type = PromotionType.all(:order => "name ASC")
    render :json =>{ :promotion_type=>@promotion_type}  
  end

  def create_photo
    @photo = @restaurant.photos.create(eval(params[:photo]))
    @photo.attachment_content_type = "image/#{@photo.attachment_file_name.split(".").last}" if !@photo.attachment_file_name.nil? 
    if  @photo.valid?
       render :json => {:status=>true}
    else
      @photos = @restaurant.photos.reload
      render :json => {:status=>false}
    end
  end


  def show_photo
    @photos = @restaurant.photos
    render :json => {:photos=>@photos}
  end
  
  def create_comments
    @comment = @parent.comments.build(eval(params[:comment]))
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
       render :json => {:status=>true}
    else
      flash[:error] = "Your comment couldn't be saved. Errors: #{@comment.errors.full_messages.to_sentence}"  
      render :json => {:status=>false}
    end
  end
  
    def show_comments
      load_and_authorize_admin_conversation
      @comments = @admin_conversation.comments.all(:include => :user).reject(&:new_record?)
      build_comment
   end

     def get_qotds
        @user = @current_user
        if params[:all]
          @qotds = @user.admin_conversations.current.paginate(:page => params[:page], :per_page => 5)
          resto_trends = @user.grouped_trend_questions.keys
          @trend_questions = (resto_trends.present? ? resto_trends : @user.solo_discussions.current).sort_by(&:scheduled_at).reverse.\
              paginate(:page => params[:page], :per_page => 5)
        else
          @qotds = @user.unread_qotds.paginate(:page => params[:page], :per_page => 5)
          resto_trends = @user.unread_grouped_trend_questions.keys
          @trend_questions = (resto_trends.present? ? resto_trends : @user.unread_solo_discussions).sort_by(&:scheduled_at).reverse.\
              paginate(:page => params[:page], :per_page => 5)

        end

      @data = Array.new
      @qotds.each do |admin_conversation|  
        @data .push(
            [admin_conversation.admin_message,
            admin_conversation]
        )
      end  
    render :json =>@data
  end

  def get_newsfeed
      all_promotions = @restaurant.promotions.all(:order => "created_at DESC")
      promotion_clumn =  Promotion.columns
      promotion_array = Array.new

      all_promotions.each do |promotion|
          promotion_keys = Hash.new
          promotion_clumn.map {|c| c.name }.each{|x| promotion_keys[x] = nil}
          promotion_clumn.map {|c| promotion_keys[c.name] = promotion[c.name] } 
          promotion_keys[:promotion_name] = promotion.promotion_type.name.gsub!(/(<[^>]*>)|\r|\n|\t/s) {" "}
          promotion_keys[:details] = promotion.details.gsub!(/(<[^>]*>)|\r|\n|\t/s) {" "}

          promotion_array.push(promotion_keys)
      end
    render :json => {:all_promotions=>promotion_array }
  end


  private

  def comment_share?
    (params[:post_to_facebook].to_s == "1") && params[:comment_id]
  end

  def build_comment
    @comment = @admin_conversation.comments.build(:user => current_user)
    @comment.attachments.build if @admin_conversation.admin_message.attachments_allowed?
    @comment_resource = [@admin_conversation, @comment]
  end
   
  def load_and_authorize_admin_conversation
    @admin_conversation = Admin::Conversation.find(params[:id], :include => :admin_message, :order => 'created_at DESC')
    unauthorized! if cannot? :read, @admin_conversation
  end

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


  def require_manager
     find_restaurant
     if cannot? :edit, @restaurant
      status = false
      render :json => {:status=>false,:message=>"You don't have permission to access that page"}
    end
  end  

     def find_restaurant
       @restaurant = Restaurant.find(params[:restaurant_id])
     end
 
  def require_restaurant_employee
    @restaurant = Restaurant.find(params[:restaurant_id])
    unless @restaurant.employees.include?(@current_user) || @current_user.admin?
      status = false
      render :json => {:status=>false,:message=>"You must be an employee of restaurant to answer and edit questions"}
    else
      return true
    end
  end

  def find_activated_restaurant
        @restaurant = Restaurant.find(params[:restaurant_id])
      unless @restaurant.is_activated?
        return false
      end
  end

  def require_user
    @user_session = UserSession.new(params)
    if @user_session.save
       @current_user = @user_session.user
    else   
      render :json =>{:status=>false,:message=>"Login failed"}
    end
  end

end
