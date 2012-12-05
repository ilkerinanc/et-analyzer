Twitter.configure do |config|
  # emergentweet_et hesabinin credentiallari
	if Rails.env.development?
  		config.consumer_key       = 'cML7S7lbEap7L73IjShVA'
  		config.consumer_secret    = 'HJXs0qX9vCmg2heaWU2ibXkq7TCT10A8Av2kGvzT6CA'
  		config.oauth_token        = '983351918-AdgxBpg3sGixgZBnqegH9Kzey2ITybOhtk73CqWq'
  		config.oauth_token_secret = 'lvkv4qMj6VAuRmSLqJjXqAWUrIEOEhFXiXVf9XHoPk'
  	else
		  config.consumer_key       = 'cML7S7lbEap7L73IjShVA'
      config.consumer_secret    = 'HJXs0qX9vCmg2heaWU2ibXkq7TCT10A8Av2kGvzT6CA'
      config.oauth_token        = '983351918-AdgxBpg3sGixgZBnqegH9Kzey2ITybOhtk73CqWq'
      config.oauth_token_secret = 'lvkv4qMj6VAuRmSLqJjXqAWUrIEOEhFXiXVf9XHoPk'
  	end
end

# TweetStream.configure do |config|
# 	if Rails.env.development?
#   		config.consumer_key       = 'zG8ENyShpw4OL7yjZjAEA'
#   		config.consumer_secret    = 'ATKGH4kEKknRisTNHNVbpMeNdl8CTFg5uzk'
#   		config.oauth_token        = '69438905-LiKauMOAGsKwc2GVaiaEfV4aan8EElW7r7ZZ6csVU'
#   		config.oauth_token_secret = 'OdPhuQXKxCdlH8h6utqCsu02NaPQQ2vjnnRcFrnGtM'
#   		config.auth_method        = :oauth
#   	else
# 		config.consumer_key       = 'IImwzRTZxuBAiCwA02hqA'
#   		config.consumer_secret    = 'sUlhPbuejHqZEGR2DoCUJmXKwYSORBmJZCyGdS5YQY'
#   		config.oauth_token        = '69438905-7QOqeQBT4Kmz7Q2SX3R5Sji1y63K8PVAFZZaf9A'
#   		config.oauth_token_secret = 'rrY8k9c8HvF5xBlxqu0rBxQ7s3nofLjcNRLvIwlRis'
#   		config.auth_method        = :oauth
#   	end
# end