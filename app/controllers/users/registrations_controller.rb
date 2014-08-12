require 'ipaddr'

class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_filter :require_no_authentication
  before_filter :deny_access, :only => 'new'

  def deny_access
    allowip = IPAddr.new(Designax::Application.config.allowip)
    remote_ip = IPAddr.new(request.env["HTTP_X_FORWARDED_FOR"] || request.remote_ip)

    if allowip.include?(remote_ip)
      return true
    end
    logMessage = self.class.to_s + "#" + __method__.to_s + " " + current_user.username + remote_ip.to_s
    logger.debug logMessage

    redirect_to new_user_session_path, :alert=>'You are not allow to access this URL.'
    return false
  end
end
