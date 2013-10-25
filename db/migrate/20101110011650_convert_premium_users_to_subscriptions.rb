#encoding: utf-8 
class ConvertPremiumUsersToSubscriptions < ActiveRecord::Migration
  def self.up
    User.find_all_by_premium_account(true).each { |u| u.make_complimentary! }
    Restaurant.find_all_by_premium_account(true).each { |r| r.make_complimentary! }
  end

  def self.down
    # nothing to reverse
  end
end
