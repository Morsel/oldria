# == Schema Information
# Schema version: 20100825200638
#
# Table name: nonculinary_jobs
#
#  id                 :integer         not null, primary key
#  profile_id         :integer
#  company            :string(255)     default(""), not null
#  title              :string(255)     default(""), not null
#  city               :string(255)     default(""), not null
#  state              :string(255)     default(""), not null
#  country            :string(255)     default(""), not null
#  date_started       :date            not null
#  date_ended         :date
#  responsibilities   :text            default(""), not null
#  reason_for_leaving :text            default(""), not null
#  created_at         :datetime
#  updated_at         :datetime
#

class NonculinaryJob < ActiveRecord::Base
  belongs_to :profile

  validates_presence_of :company, :title, :city, :state, :country, :date_started, :responsibilities

end
