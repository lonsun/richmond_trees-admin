class Notifier < ActionMailer::Base
  default from: "do-not-reply@richmondtrees.org"

  def activate_account( user )
    @perishable_token = user.perishable_token
    mail( subject: "Richmond Trees - Activate Your Account", to: user.email )
  end

  def password_reset( user )
    @perishable_token = user.perishable_token
    mail( subject: "Richmond Trees - Password Reset Instructions", to: user.email )
  end
end
