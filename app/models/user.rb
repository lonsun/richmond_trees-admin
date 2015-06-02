class User < ActiveRecord::Base
	# add authlogic
	acts_as_authentic
end
