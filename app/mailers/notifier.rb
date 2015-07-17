class Notifier < ActionMailer::Base
  default from: "do-not-reply@richmondtrees.org"

  def password_reset( user )
    @perishable_token = user.perishable_token
    mail( subject: "Richmond Trees - Password Reset Instructions", to: user.email )
  end
end
