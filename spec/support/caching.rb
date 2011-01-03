class FakeMemCacheStore
  def read(key, options = nil)
    @data[key.to_s]
  end

  def write(key, value, options = nil)
    @data ||= {}
    @data[key.to_s] = value
  end

  def exist?(key, options = nil)
    !read(key).nil?
  end

  def clear
    @data = {}
  end

  def delete(key, options = nil)
    @data.delete(key) if @data.key?(key)
  end

  def method_missing(m, *args, &block)  
    raise "FakeMemCacheStore object! MethodName: #{m.to_s}"
  end
end

def enable_memcache_stub
  ActiveSupport::Cache::MemCacheStore.class_eval do 
    def self.new(*addresses)
      @instance ||= FakeMemCacheStore.new #super(*addresses)
    end
  end
  ActionController::Base.perform_caching = true
  ActionController::Base.cache_store = ActiveSupport::Cache::MemCacheStore.new "localhost"
  Rails.module_eval do 
    def self.cache
      ActiveSupport::Cache::MemCacheStore.new "localhost"
    end
  end
end

