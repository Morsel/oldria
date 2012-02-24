module MailerHelper

  def url_for_message(message)
    if @message.respond_to?(:admin_message)
      admin_conversation_url(@message)
    elsif message.is_a?(ProfileQuestion)
      user_btl_chapter_path(:user_id => @recipient.id, :id => message.chapter.id)
    else
      polymorphic_url(@message)
    end
  end

end
