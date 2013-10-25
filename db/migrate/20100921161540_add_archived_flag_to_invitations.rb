#encoding: utf-8 
class AddArchivedFlagToInvitations < ActiveRecord::Migration
  def self.up
    add_column :invitations, :archived, :boolean, :default => false
  end

  def self.down
    remove_column :invitations, :archived
  end
end
