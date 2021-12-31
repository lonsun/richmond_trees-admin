class UserSession < Authlogic::Session::Base
	validate :check_required_fields

    logout_on_timeout true

	private
		def check_required_fields
			errors.add(:username, "is required") unless username_valid?
		end

		# TODO: add a test for this
		def username_valid?
			return false if :username.nil? || :username.empty?
			return true
		end
end
