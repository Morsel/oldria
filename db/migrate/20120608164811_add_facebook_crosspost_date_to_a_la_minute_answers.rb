#encoding: utf-8 
class AddFacebookCrosspostDateToALaMinuteAnswers < ActiveRecord::Migration
  def self.up
    add_column :a_la_minute_answers, :post_to_facebook_at, :datetime
  end

  def self.down
    remove_column :a_la_minute_answers, :post_to_facebook_at
  end
end
