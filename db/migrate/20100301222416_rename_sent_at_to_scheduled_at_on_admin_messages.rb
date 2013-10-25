#encoding: utf-8 
class RenameSentAtToScheduledAtOnAdminMessages < ActiveRecord::Migration
  def self.up
    change_table :admin_messages do |t|
      t.rename :sent_at, :scheduled_at
    end
  end

  def self.down
    change_table :admin_messages do |t|
      t.rename :scheduled_at, :sent_at
    end
  end
end