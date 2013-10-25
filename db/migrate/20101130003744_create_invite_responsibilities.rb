#encoding: utf-8 
class CreateInviteResponsibilities < ActiveRecord::Migration
  def self.up
    create_table :invite_responsibilities do |t|
      t.integer :invitation_id
      t.integer :subject_matter_id

      t.timestamps
    end
  end

  def self.down
    drop_table :invite_responsibilities
  end
end
