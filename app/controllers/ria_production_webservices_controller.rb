class RiaProductionWebservicesController < ApplicationController

  skip_before_filter :protect_from_forge
  before_filter :require_user,:only => [:a_la_minute_answers,:require_restaurant_employee,:menu_items,:bulk_update,:create_menu,:create_promotions,:create_photo,:show_photo,:create_comments,:get_qotds,:get_newsfeed,:push_notification_user,:get_media_request]
  before_filter :require_restaurant_employee, :only => [:a_la_minute_answers,:require_restaurant_employee,:menu_items,:bulk_update,:create_menu,:create_promotions,:create_photo,:show_photo,:get_newsfeed]
  before_filter :find_activated_restaurant, :only => [:a_la_minute_answers,:require_restaurant_employee,:menu_items,:bulk_update,:create_menu,:create_promotions,:create_photo,:show_photo,:get_newsfeed]
  before_filter :require_manager, :only => [:a_la_minute_answers,:require_restaurant_employee,:menu_items,:bulk_update,:create_menu,:create_promotions,:create_photo,:show_photo,:get_newsfeed]
  before_filter :find_parent, :only => [:create_comments]

  layout false
  include ALaMinuteAnswersHelper

  def api_register    

    if params[:role] == "diner" && !params[:url].blank?
      @subscriber = NewsletterSubscriber.build_from_registration(params)
      if @subscriber.save
        status = true
      else
        status = false
      end
    end
    
    unless params[:url].blank?
      url = params[:url]
      url = "#{url}" unless url.match(/\.$/)
      url = "http://#{url}" unless url.match(/^https?:\/\//)      
      status ? redirect_to([url, '?success=1'].join) : redirect_to([url, '?success=0'].join)
     else
      render :text=>"Return url not found." 
    end
      
  end
    
  def register    
     message = []
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
         message.push("Your changes have been saved")
         status  = true
      else

        @invitation.errors.full_messages.each do |msg|
          message.push(msg.gsub(/(<[^>]*>)|\r|\n|\t/s) {" "})
        end 

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
        message.push("Invalid request")
    end
    render :json => {:status=>status,:message=>message}
  end

  def get_join_us_value
     render :json =>{ :restaurantRole=>RestaurantRole.all,:subjectMatter=>SubjectMatter.all}
  end

  def create
   @user_session = UserSession.new(params)
    save_session
  end

  def save_session
    if @user_session.save
        user = @user_session.user
        @user_restaurants =user.restaurants
        @restaurants = @user_restaurants.find(:all ,:select=>"restaurants.id,name")
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
        render :json => {:status=>status,:restaurants=>@restaurants}

    else
       if @user_session.errors.on_base == "Your account is not confirmed"
          status = false
      elsif @user_session.errors.on(:username) || @user_session.errors.on(:password)
          status = false
      else
        status = false
      end
     render :json => {:status=>status,:message=>"Oops, you entered the wrong username or password.;"}
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
       render :json =>{:status=>status,:message=>"Your account is not confirmed.Please check your email for instructions"}
    end
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    UserMailer.deliver_password_reset_instructions(self)
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
      no_twitter_crosspost = attributes[:no_twitter_crosspost]
      if(no_twitter_crosspost.to_i < 1)
        attributes[:twitter_posts_attributes] = {}
        attributes[:twitter_posts_attributes]["0"]={:post_at =>attributes[:post_to_twitter_at] ,:content =>""}
      end       
      attributes.delete("no_twitter_crosspost")
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
          if !menu_item.description.nil? && !menu_item.description.blank?
            menu_item.description = menu_item.description.gsub(/(<[^>]*>)|\r|\n|\t/s) {" "}
          end  
        if !menu_item.photo_file_name.nil? && !menu_item.photo_file_name.blank? 
          menu_item.photo_file_name = menu_item.photo(:thumb)
        end  
    end
        render :json => {:menu_items=>@menu_items,:keywords=>@menu_item_keywords}
  end

  def create_menu
    params[:menu_item][:otm_keyword_ids] = eval(params[:menu_item][:otm_keyword_ids])
    no_twitter_crosspost = params[:menu_item][:no_twitter_crosspost]
    if(no_twitter_crosspost.to_i < 1)
      params[:menu_item][:twitter_posts_attributes] = {}
      params[:menu_item][:twitter_posts_attributes]["0"]={:post_at =>params[:menu_item][:post_to_twitter_at] ,:content =>""}
    end      
    params[:menu_item].delete("no_twitter_crosspost") 
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

 def create_promotions     
       
    no_twitter_crosspost = params[:promotion][:no_twitter_crosspost]
    params[:promotion].delete("no_twitter_crosspost") 
    
    if(no_twitter_crosspost.to_i < 1)
      params[:promotion][:twitter_posts_attributes] = {}
      params[:promotion][:twitter_posts_attributes]["0"]={:post_at =>params[:promotion][:post_to_twitter_at] ,:content =>""}
    end    
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
    @photo = @restaurant.photos.create(params[:photo])
    @photo.attachment_content_type = "image/#{@photo.attachment_file_name.split(".").last}" if !@photo.attachment_file_name.nil? 
    if  @photo.save
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
    unless params[:media_request_discussion_id].blank? 
      @comment = @parent.comments.build(params[:comment])
      else  
      @comment = @parent.comments.build(eval(params[:comment]))
    end
    
    @comment.user_id ||= current_user.id
    @is_mediafeed = params[:mediafeed]
    if  (params[:media_request_discussion_id].blank? && @parent.comments_count == 0) || !params[:media_request_discussion_id].blank?
      if @comment.save
        render :json => {:status=>true,:message =>"Saved"}        
      else
        render :json => {:status=>false ,:message=>"Your comment couldn't be saved. Errors: #{@comment.errors.full_messages.to_sentence}"  }
      end  
    else
       render :json => {:status=>false,:message=>"Already been commented"}
    end 
  end
  
  def get_media_request
    
    if archived_view?
      @messages = current_user.viewable_media_request_discussions.sort { |a, b| b.created_at <=> a.created_at }.paginate(:page => params[:page], :per_page => 5)
    else
      @messages = current_user.viewable_unread_media_request_discussions.sort { |a, b| b.created_at <=> a.created_at }.paginate(:page => params[:page], :per_page => 5)
    end 
      @data = []
      @messages.each_with_index do |message,index|
        @data[index] = {}           
        @data[index][:restaurant]  =  message.restaurant.try(:name)
        @data[index][:id] = message.media_request.id
        @data[index][:message] = message.media_request.message
        @data[index][:due_date] = message.media_request.due_date.try(:to_s, :long_ordinal)
        @data[index][:publication] = message.media_request.publication
        @data[index][:media_request_discussion_id] = message.id
        @data[index][:comments_count] = message.comments_count
        @data[index][:inbox_title] = message.media_request.inbox_title
        @data[index][:title_date] = message.media_request.created_at.to_s(:sentence)
        
        @data[index][:comments] = {}
        message.comments.all(:include => [:user, :attachments], :order => 'created_at DESC').reject(&:new_record?).each_with_index do |comment,c_index|
            @data[index][:comments][c_index] = {}
            @data[index][:comments][c_index][:comment] = comment.comment
            @data[index][:comments][c_index][:comment_date] = comment.created_at.try(:strftime, "%b %e, %Y at %l:%M %p")
            @data[index][:comments][c_index][:attachments] = comment.attachments.map(&:attachment).map(&:url).join(",")
        end
        
    end
        render :json => {:media_request=>  @data}      
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
        admin_conversation.admin_message[:date] = admin_conversation.admin_message.scheduled_at.try(:strftime, "%B %d, %Y at %I:%M%p")
        @data .push(
            [admin_conversation.admin_message,
            admin_conversation]
        )
      end  

       @trends = Array.new
       @trend_questions.each_with_index do |trend_question,index|
          @trends[index] = Hash.new
          @trends[index]["question"] = trend_question.message
          @trends[index]["date"] = trend_question.scheduled_at.try(:strftime, "%B %d, %Y at %I:%M%p")
          @trends[index]["admin_discussions"] = Array.new
          @user.grouped_admin_discussions[trend_question].each do |trend|    
            obj = Hash.new
            obj[:admin_discussion_id] = (trend.id)      
            obj[:restaurant_id] =(trend.restaurant_id)
            obj[:is_posted] = (trend.comments_count) #comments_count
            @trends[index]["admin_discussions"].push(obj)
        end
      end   

    render :json => {:data => @data,:trends => @trends }
  end

  def get_newsfeed
      all_promotions = @restaurant.promotions.all(:order => "created_at DESC")
      promotion_clumn =  Promotion.columns
      promotion_array = Array.new
      all_promotions.each do |promotion|
          promotion_keys = Hash.new
          promotion_clumn.map {|c| c.name }.each{|x| promotion_keys[x] = nil}
          promotion_clumn.map {|c| promotion_keys[c.name] = promotion[c.name] } 
          promotion_keys[:promotion_name] = promotion.promotion_type.name.gsub(/(<[^>]*>)|\r|\n|\t/s) {" "}
          promotion_keys["details"] = promotion.details.gsub(/(<[^>]*>)|\r|\n|\t/s) {" "}
      promotion_array.push(promotion_keys)
      end
    render :json => {:all_promotions=>promotion_array }
  end

  def get_admin_discussions
    @admin_discussion = AdminDiscussion.find(params[:id])
    #unauthorized! if cannot? :read, @admin_discussion
    @discussionable = @admin_discussion.discussionable
    @comments = @admin_discussion.comments.reject(&:new_record?)
         render :json => {:comments=>@comments }
  end  

    def get_admin_conversation
    @admin_conversation = Admin::Conversation.find(params[:id], :include => :admin_message, :order => 'created_at DESC')
    #unauthorized! if cannot? :read, @admin_conversation
     render :json => {:admin_conversation=>@admin_conversation }
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
