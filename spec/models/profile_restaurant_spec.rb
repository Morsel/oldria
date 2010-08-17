# == Schema Information
# Schema version: 20100817161538
#
# Table name: profile_restaurants
#
#  id           :integer(4)      not null, primary key
#  profile_id   :integer(4)      not null
#  title        :string(255)     default(""), not null
#  city         :string(255)     default(""), not null
#  state        :string(255)     default(""), not null
#  date_started :date            not null
#  date_ended   :date
#  chef_name    :string(255)     default(""), not null
#  chef_is_me   :boolean(1)      not null
#  cuisine      :text            default(""), not null
#  notes        :text            default(""), not null
#  created_at   :datetime
#  updated_at   :datetime
#

require 'spec_helper'

describe ProfileRestaurant do
  should_belong_to :profile

end
