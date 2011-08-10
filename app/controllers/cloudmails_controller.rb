class CloudmailsController < ApplicationController

  skip_before_filter :verify_authenticity_token
  skip_before_filter :require_user

  EMAIL_SEPARATOR = 'Respond by replying to this email - above this line'

  before_filter :verify_cloudmail_signature
  
  def create
    mail_token = params[:to].split('@').first.gsub('<','')
    
    # use this if you need to debug
    Rails.logger.info %Q{#{'*'*72}\nReceiving email message with mail_token: #{mail_token}\n#{'*'*72}\n#{params[:plain]}\n#{'*'*72}}
    
    # Some mail clients give us plaintext and html, some only give us plaintext
    whole_message_body = if params[:plain].present?
      message = params[:plain]
      message.gsub!(/\r\n/, "\n") # Converting carriage returns
      message.gsub!(/\n>/, "\n") # Removing symbols to indicate quoting

      # Remove any residual html in the quoted text
      Loofah.fragment(message).scrub!(:strip).text
    elsif params[:html].present?
      message = params[:html]
      message.gsub!("\r\n", "\n") # Converting carriage returns
      message.gsub!(/&nbsp;/, " ") # Clean this because it doesn't seem to convert well
      message.gsub!(/<br\/*>/, "\n") # Converting html breaks into newlines
      message.gsub!(/\n>/, "\n") # Removing symbols to indicate quoting
      Loofah.document(message).scrub!(:strip).text
    else
      Rails.logger.info('No readable message received')
      render :text => 'No readable message received',
             :status => 200
    end

    # Get IDs from the mail token
    user_id, cloudmail_hash, message_type, message_id = mail_token.split('-')
    message_type = message_type.downcase

    user = User.find(user_id)
    original_message = case message_type
    when "qotd"
      Admin::Conversation.find(message_id)
    when "btl"
      ProfileQuestion.find(message_id)
    when "rd" # Restaurant-based Trend Question Discussion
      AdminDiscussion.find(message_id)
    when "sd" # Individual user TQ discussion
      SoloDiscussion.find(message_id)
    end

    # abort unless we can find our seperator 'Respond by replying to this email - above this line'
    unless whole_message_body.include?(EMAIL_SEPARATOR)
      Rails.logger.info('Email answer does not include separator text')
      render :text => 'Email answer does not include separator text',
             :status => 200
      UserMailer.deliver_answerable_message_error(original_message, user,
        "We couldn't find the \"#{EMAIL_SEPARATOR}\" text needed to process this message. Please try replying again, and do not edit any of the quoted text.")
      return
    end

    # clean it up to get what the user intends we get (as best as we can)
    message_body = process_email_body(whole_message_body)

    if message_body.length < 5
      Rails.logger.info 'Email answer was too short'
      render :text => 'Your answer was too short, or could not be read properly', :status => 200
      UserMailer.deliver_answerable_message_error(original_message, user,
          "Your answer was too short, or could not be read properly. Please try again by replying to this message.")
      return
    elsif (message_type == "btl" && original_message.answered_by?(user)) || \
       (message_type != "btl" && original_message.comments.count > 0)
      Rails.logger.info 'User submitted a reply to a discussion or question that already has one'

      render :text => 'This is a duplicate reply. Please edit your response on the Spoonfeed site.', :status => 200

      UserMailer.deliver_answerable_message_error(original_message, user,
          ((message_type == "rd") ? "You already responded to this message, or a coworker beat you to it. Use the link below to review and edit your comments." :
                                 "You already responded to this message. Use the link below to edit your comments."), false)

      return
    end

    user.validate_cloudmail_token!(cloudmail_hash, original_message)

    original_message.create_response_for_user(user, message_body)

    # use this if you need to debug
    Rails.logger.info %Q{#{'*'*72}\nCleaned Message:\n#{message_body}\n#{'*'*72}}

    # cloudmailin likes this response
    render :text => 'success', :status => 200
  end

  private

    # Clean up the email text and extract the user's reply
    def process_email_body(message_body)
      # take everything in front of the first 'Respond by replying to this email - above this line'
      message_body = message_body.split(EMAIL_SEPARATOR).first

      # remove any leading or trailing spaces
      message_body.strip!

      # clean up the newlines
      message_body.gsub!(/[\s]*\n[\s]*/, "\n")

      # for the next transformation it makes things easier if we have new lines at the begining and end
      message_body = "\n#{message_body}\n"

      stop_words = [/notifications[@=]restaurantintelligenceagency.com/,
                    /Sent from my [\w ]+\s*/,
                    /Sent from myTouch [\w ]+\s*/,
                    /Sent via [\w ]+\s*/,
                    /\s*On (mon|tue|wed|thu|fri|sat|sun).* at \d+\:\d\d (AM|PM)[^a-zA-Z0-9]*/i,
                    /\s*On (mon|tue|wed|thu|fri|sat|sun).* at \d+\:\d\d[^a-zA-Z0-9]*/i,
                    /.*subject\:.*/i,
                    /.*to\:.*/i,
                    /.*date\:.*/i,
                    /.*sent\:.*/i,
                    /-*Original Message-*/,
                    /---+/,
                    /^#yiv/,
                    /^Email$/,
                    /^td\{/,
                    /border:1px solid red;/]

      message_lines = message_body.split("\n").reject { |line|
        stop_words.any? { |word| line.match(word) }
      }

      message_body = message_lines.join("\n")

      # if the last line contains any of these expressions, then remove it
      3.times do
        message_body.gsub!(/\s*$/i, "\n")
      end

      # remove any lines which dont contain at least one alpha numeric
      message_body.gsub!(/\n[^a-zA-Z0-9]+\n/,"\n")

      # remove any leading or trailing spaces
      message_body.strip!
    
      return message_body
    end
    
    # sign the params, and check they actually came from cloudmailin
    def verify_cloudmail_signature
      provided = request.request_parameters.delete(:signature)
      signature = Digest::MD5.hexdigest(request.request_parameters.sort.map{|k,v| v}.join + CLOUDMAIL_SECRET)

      if provided != signature
        render :text => "Message signature error #{provided} != #{signature}", :status => 403
        return false 
      end
    end

end
