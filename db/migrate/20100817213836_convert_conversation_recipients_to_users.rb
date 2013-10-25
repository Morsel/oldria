#encoding: utf-8 
class ConvertConversationRecipientsToUsers < ActiveRecord::Migration
  def self.up
    # convert employment ids to employee (user) ids
    Admin::Conversation.all.each do |c|
      if Employment.exists?(c.recipient_id) && (employment = Employment.find(c.recipient_id))
        c.update_attribute(:recipient_id, employment.employee_id)
      else
        say "Warning: no such Employment: #{c.recipient_id}"
        say "Warning: Erasing the defunct conversation..."
        c.destroy
      end
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
