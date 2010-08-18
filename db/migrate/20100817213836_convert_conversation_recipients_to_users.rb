class ConvertConversationRecipientsToUsers < ActiveRecord::Migration
  def self.up
    # convert employment ids to employee (user) ids
    Admin::Conversation.all.each do |c|
      c.update_attribute(:recipient_id, Employment.find(c.recipient_id).employee.id)
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
