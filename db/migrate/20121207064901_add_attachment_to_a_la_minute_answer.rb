class AddAttachmentToALaMinuteAnswer < ActiveRecord::Migration
  def self.up
    add_column :a_la_minute_answers, :attachment_file_name, :string
    add_column :a_la_minute_answers, :attachment_content_type, :string
    add_column :a_la_minute_answers, :attachment_file_size, :integer
    add_column :a_la_minute_answers, :attachment_updated_at, :datetime
  end

  def self.down
    remove_column :a_la_minute_answers, :attachment_updated_at
    remove_column :a_la_minute_answers, :attachment_file_size
    remove_column :a_la_minute_answers, :attachment_content_type
    remove_column :a_la_minute_answers, :attachment_file_name
  end
end
