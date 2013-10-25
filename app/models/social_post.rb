class SocialPost < ActiveRecord::Base  
  POST_LIMIT = 3
  REJECT_PROC = lambda { |params| params["post_at"].blank? }
  attr_accessible :payload_object, :priority, :run_at
  belongs_to :source, :polymorphic => true
  has_one :delayed_job, :class_name => "Delayed::Job", :foreign_key => 'id', :primary_key => 'job_id', :dependent => :destroy

  after_save :schedule_post

  scope :pending, :conditions => ['post_at > ?', DateTime.now.ago(7.days)],:order=>"post_at desc"
  
  def posted?
    post_at.present? ? post_at < DateTime.now : false
  end

  private

  def schedule_post
    if post_at_changed?
      delayed_job.destroy if delayed_job.present?
      job = self.send_at(post_at, :post)
      self.class.update_all("job_id = #{job.id}", ["id = ?", self.id])
    end
  end
end
