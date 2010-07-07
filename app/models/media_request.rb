# == Schema Information
# Schema version: 20100426230131
#
# Table name: media_requests
#
#  id                    :integer         not null, primary key
#  sender_id             :integer
#  message               :text
#  created_at            :datetime
#  updated_at            :datetime
#  due_date              :date
#  media_request_type_id :integer
#  fields                :text
#  status                :string(255)
#  publication           :string(255)
#  admin                 :boolean
#

class MediaRequest < ActiveRecord::Base
  serialize :fields, Hash

  belongs_to :sender, :class_name => 'User'
  belongs_to :media_request_type
  has_many :media_request_discussions, :dependent => :destroy
  belongs_to :employment_search

  # Recipients are Employment objects, not Employees directly
  has_many :restaurants, :through => :media_request_discussions
  has_many :attachments, :as => :attachable, :class_name => '::Attachment', :dependent => :destroy
  validates_presence_of :sender_id
  validates_presence_of :restaurant_ids, :on => :create

  accepts_nested_attributes_for :attachments

  named_scope :past_due, lambda {{ :conditions => ['due_date < ?', Date.today] }}
  named_scope :for_dashboard, :order => "created_at DESC", :conditions => {:status => ["approved", "pending"]}

  include AASM

  before_validation :build_employment_search_if_needed
  before_validation :update_restaurants_from_search_criteria

  aasm_column :status
  aasm_initial_state :pending
  aasm_state :pending
  aasm_state :approved
  aasm_state :closed

  aasm_event :approve, :success => :deliver_notifications do
    transitions :to => :approved, :from => [:pending]
  end

  def deliver_notifications
    # for conversation in self.media_request_discussions
    #   UserMailer.deliver_media_request_notification(self, conversation)
    # end
  end
  handle_asynchronously :deliver_notifications # Use delayed_job to send


  def discussion_with_restaurant(restaurant)
    media_request_discussions.first(:conditions => {:restaurant_id => restaurant.id})
  end

  def publication_string
    "A writer" + from_publication
  end

  def reply_count
    @reply_count ||= media_request_discussions.count(:conditions => 'comments_count > 0')
  end

  def discussions_with_comments
    media_request_discussions.all(:conditions => 'comments_count > 0')
  end

  def message_with_fields(before_key = '', after_key = ': ')
    message_with_fields = fields.inject("") do |result, (key,value)|
      result += "#{before_key + key.to_s.humanize + after_key + value}\n"
    end
    return message_with_fields if message.blank?
    message_with_fields += "\n#{message}"
  end

  def fields=(fields)
    fields.delete_if {|k,v| v.blank? } if fields.respond_to?(:delete_if)
    write_attribute(:fields, fields)
  end

  def fields
    read_attribute(:fields) || Hash.new
  end

  def viewable_by?(employment)
    return false unless employment
    employment.employee == employment.restaurant.try(:manager) ||
    employment.omniscient? ||
    employment_search.employments.include?(employment)
  end

  private

  def from_publication
    self.publication.blank? ? "" : " from #{self.publication}"
  end

  def build_employment_search_if_needed
    build_employment_search(:conditions => {}) if self.employment_search.blank?
  end

  def update_restaurants_from_search_criteria
    self.restaurant_ids = employment_search.restaurant_ids if employment_search
  end
end
