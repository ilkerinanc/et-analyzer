uri = URI.parse(YAML.load_file("#{Rails.root}/config/redis.yml")[Rails.env])
Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password, :thread_safe => true)
# Sense::Redis.scopes.merge!({:models => Redis::Namespace.new('sense:models', :redis => Sense::Redis.redis)})
# Redis.current = Sense::Redis.redis
# Resque.redis = Sense::Redis.redis