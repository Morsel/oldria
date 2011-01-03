module RiaCaching

  # get result from cache with method name as key.
  # if no key found  or refresh is true 
  # it calls passed method for result and 
  # save to cache
  def cache_or_get(method_name, refresh = false)
    method_name = method_name.to_s unless method_name.is_a?(String)
    unless self.perform_caching && (result = Rails.cache.read(method_name)) && !refresh
      result = send(method_name)
      Rails.cache.write(method_name, result, :expires_in => 5.minutes) if self.perform_caching
    end
    result
  end

  
  # preload classes which may be used while caching
  # to prevent "undefined class/module"
  def preload_classes
    ProfileAnswer
  end

  # delete cached data
  # created by caches_action
  # with cache_path
  def expire_action_by_key(key)
    Rails.cache.delete(action_cache_key(key.to_s))
  end

  # return cache key for each controller/action pair
  # for logged in users
  # ex "welcomeindex205"
  def cache_key(controller, action, uid = nil)
    controller.to_s + action.to_s + uid.to_s
  end

  # when rails cache action with custom
  # cache path it adds prefix such as "views"
  # for cache key
  def action_cache_key(cache_key)
    "views/#{cache_key.to_s}"
  end
end
