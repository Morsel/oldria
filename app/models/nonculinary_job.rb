class NonculinaryJob < ActiveRecord::Base
  belongs_to :profile

  validates_presence_of :company, :title, :city, :state, :country, :date_started, :responsibilities

end
