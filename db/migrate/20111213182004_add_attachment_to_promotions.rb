#encoding: utf-8 
class AddAttachmentToPromotions < ActiveRecord::Migration
  def self.up
    add_column :promotions, :attachment_file_name, :string
    add_column :promotions, :attachment_content_type, :string
    add_column :promotions, :attachment_file_size, :integer
    add_column :promotions, :attachment_updated_at, :datetime
  end

  def self.down
    remove_column :promotions, :attachment_updated_at
    remove_column :promotions, :attachment_file_size
    remove_column :promotions, :attachment_content_type
    remove_column :promotions, :attachment_file_name
  end
end
