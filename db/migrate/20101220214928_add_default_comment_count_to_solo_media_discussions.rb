#encoding: utf-8 
class AddDefaultCommentCountToSoloMediaDiscussions < ActiveRecord::Migration
  def self.up
    change_column_default :solo_media_discussions, :comments_count, 0
  end

  def self.down
  end
end