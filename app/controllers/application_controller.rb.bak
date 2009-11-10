# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  ensure_application_is_installed_by_facebook_user
  attr_accessor :current_user
  before_filter :set_current_user
  
  def set_current_user
    self.current_user = User.for(facebook_session.user.to_i)
  end

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
