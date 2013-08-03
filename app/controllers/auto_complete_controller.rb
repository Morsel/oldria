class AutoCompleteController < ApplicationController

  include AutoCompleteHelper
  
  def index
    respond_to do |format|
      if params[:metro]
        format.js { auto_complete_metropolitan_keywords }
      elsif params[:person]
        format.js { auto_complete_person_keywords }
      else
        format.js { auto_complete_keywords }
      end
    end
  end
  
  def auto_complete_keywords
    @keywords = get_autocomplete_restaurant_result
    unless @keywords.present?      
      render :json => @keywords.push('No results found, please try a new search')
    else            
      render :json => @keywords
    end
  end

  def auto_complete_person_keywords
    @keywords = get_autocomplete_person_result    
    unless @keywords.present?      
      render :json => @keywords.push('No results found, please try a new search')
    else      
      render :json => @keywords
    end
  end

  def auto_complete_metropolitan_keywords
    keyword_name = params[:term]
    @keywords = MetropolitanArea.find(:all,:conditions => ["state like ?", "%#{keyword_name}%"],:limit => 15).map(&:state).uniq
    unless @keywords.present?
      render :json => @keywords.push('This keyword does not yet exist in our database.')
    else
      render :json => @keywords
    end
  end

end