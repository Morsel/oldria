#encoding: utf-8 
class CreateInvitations < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :title
      t.boolean :coworker, :default => false
      t.integer :restaurant_id
      t.string :restaurant_name
      t.integer :requesting_user_id
      t.integer :invitee_id
      t.datetime :approved_at

      t.timestamps
    end
  end

  def self.down
    drop_table :invitations
  end
end
