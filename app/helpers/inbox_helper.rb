module InboxHelper
  def reply_link_for_message(message)
    return unless message
    puts "\n\n\n"
    puts message
    puts "\n\n\n"
    if message.respond_to?(:holiday)
      puts "Yes"
      link_to "Reply", holiday_conversation_path(message)
    elsif message.respond_to?(:admin_message)
      link_to "Reply", admin_conversation_path(message)
    end
  end
end