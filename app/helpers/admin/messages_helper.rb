module Admin::MessagesHelper

  def link_for_conversation(conversation)
    conversation_type = conversation.admin_message.class.title
    conversation_date = content_tag(:span, conversation.created_at.strftime("%m/%d:"))
    link_to("#{conversation_date} #{conversation_type}", conversation)
  end
end
