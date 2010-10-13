if (Rails.env.development? or Rails.env.test?)
  begin
    require 'metric_fu'
    MetricFu::Configuration.run do |config|
       config.rcov[:rcov_opts] << "-Ispec"
    end
  rescue LoadError
  end
end