# == Schema Information
#
# Table name: subject_matters
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class SubjectMatter < ActiveRecord::Base
  has_many :responsibilities, :dependent => :destroy
  has_many :employments, :through => :responsibilities
  has_many :request_categorizations
  has_many :media_requests, :through => :request_categorizations

  validates_presence_of :name
  default_scope :order => "#{table_name}.name ASC"

  named_scope :nongeneral, :conditions => ["general IS NULL OR general = ?", false]

  def admin_only?
    name =~ /RIA/
  end
end
