module DelayedJobSpecHelper
  def perform_delayed_jobs
    Delayed::Job.all.each do |job|
      job.payload_object.perform
      job.destroy
    end
  end
end