module MailerHelper

  def url_for_message(message)
    if @message.respond_to?(:admin_message)
      admin_conversation_url(@message)
    elsif message.is_a?(ProfileQuestion)
      user_questions_url(:user_id => @recipient.id, :chapter_id => message.chapter.id)
    else
      polymorphic_url(@message)
    end
  end

end
