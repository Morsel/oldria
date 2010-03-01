module Admin::MessagesHelper

  def date_for_admin_message(message)
    content_tag(:span, message.updated_at.strftime("%m/%d:"))
  end

  def link_for_conversation(conversation)
    conversation_type = conversation.admin_message.class.title
    conversation_date = date_for_admin_message(conversation.admin_message)
    link_to("#{conversation_date} #{conversation_type}", conversation)
  end

  def link_for_message(message)
    message_type = message.class.title
    message_date = date_for_admin_message(message)
    link_to("#{message_date} #{message_type}", admin_message_path(message))
  end
end
