class CloudmailsController < ApplicationController

  skip_before_filter :verify_authenticity_token
  skip_before_filter :require_user

  # cloudmailin wasnt finished with this feature yet
  # before_filter :verify_cloudmail_signature
  
  def create

    disposable = params[:disposable]
    
    # use this if you need to debug
    Rails.logger.info %Q{
    #{'*'*72}
     Receiving email message with disposable : #{params[:disposable]}
     #{'*'*72}
     #{params[:plain]}
     #{'*'*72}
    }
    
    # some email clients convert all this for us, and send a plan text version others just give us html
    # choose a version of the email body we can work with, after this point it should not include any html
    whole_message_body = ( params[:plain].length > 50 ) ? params[:plain] : params[:html].gsub(/<\/?[^>]*>/, "\n")
    
    # abort unless we can find our seperator 'Reply ABOVE THIS LINE'
    unless whole_message_body.include? 'Reply ABOVE THIS LINE'
      render :text => 'Im sorry, we had a problem automatically adding your answer, please try again or answer on the website.', :status => 422
      return
    end

    # take everything infront of the first 'Reply ABOVE THIS LINE'
    message_body = whole_message_body.split('Reply ABOVE THIS LINE').first

    # clean it up to get what the user intends we get (as best as we can)
    message_body = clean_email_body(message_body)

    # everything we need is in the disposable part of the email address
    user_id, cloudmail_hash, message_id = disposable.split('-')
    
    # get the models
    user = User.find user_id
    conversation = Admin::Conversation.find(message_id)

    # ensure this user is who they say they are
    user.validate_cloudmail_token!(cloudmail_hash, conversation)

    if message_body.length < 10
      render :text => 'Your answer was too short, or could not be read properly', :status => 422
      return
    end
    
    conversation.comments.create(:user => user, :comment => message_body)

    # cloudmailin likes this response
    render :text => 'success', :status => 200
  end


  private 
    # tries to clean the email body, differnet email clients modify the text in different ways
    def clean_email_body message_body
    
      # remove any leading or trailing spaces
      message_body.strip!

      # clean up the newlines
      message_body.gsub!(/\s*\n\s*/,"\n")

      # for the next transformation it makes things easier if we have new lines at the begining and end
      message_body = "\n#{message_body}\n"
      #remove any lines which dont contain at least one alpha numeric
      message_body.gsub!(/\n[^a-zA-Z0-9]+\n/,"\n")

      # remove any leading or trailing spaces
      message_body.strip!

      # if the last line contains any of these expressions, then remove it
      3.times do
        message_body.gsub!(/\s*$/i,"")
        message_body.gsub!(/\nSent from my [\w ]+\s*$/i,"")
        message_body.gsub!(/\n.*wrote\:\s*$/i,"")
        message_body.gsub!(/\n.*from\:\s*$/i,"")
        message_body.gsub!(/\n.*sent\:\s*$/i,"")
        message_body.gsub!(/\n\s*On (mon|tue|wed|thu|fri|sat|sun).* at \d+\:\d\d (AM|PM)[^a-zA-Z0-9]*$/i,"")
        message_body.gsub!(/\n\s*On (mon|tue|wed|thu|fri|sat|sun).* at \d+\:\d\d[^a-zA-Z0-9]*$/i,"")
      end

      # remove any leading or trailing spaces
      message_body.strip!
    
      return message_body
      
    end
    
    # sign the params, and check they actually came from cloudmailin
    def verify_cloudmail_signature
      provided = request.request_parameters.delete(:signature)
      signature = Digest::MD5.hexdigest(request.request_parameters.sort.map{|k,v| v}.join + CLOUDMAIL_SECRET)

      if provided != signature
        render :text => "Message signature fail #{provided} != #{signature}", :status => 403
        return false 
      end
    end
end
