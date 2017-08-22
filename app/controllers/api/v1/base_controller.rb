class Api::V1::BaseController < ApplicationController
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :deny_access

  #disable the CSRF token
  protect_from_forgery with: :null_session

  #disable cookies (no set-cookies header in response)
  before_filter :destroy_session

  #disable the CSRF token
  skip_before_filter :verify_authenticity_token

  attr_accessor :current_user
  skip_before_filter :authorize

  def destroy_session
    request.session_options[:skip]=true
  end

  def api_error(opts = {})
    render nothing: true, status: opts[:status]
  end

  def authenticate_user!
    token = ActionController::HttpAuthentication::Token.token_and_options(request)

    user_email = params[:user][:email]
    user = user_email && User.find_by_email(user_email)
    #logger.info("user_email=>#{user_email};user=>#{user.inspect}")
    #logger.info("token=>#{token}")
    #logger.info("user_token=>#{user.authentication_token}")

    if user && secure_compare(user.authentication_token, token[0])
      self.current_user = user
    else
      return unauthenticated!
    end
  end

  def unauthenticated!
    api_error(status: 401)
  end
  
  def deny_access
    api_error(status: 403)
  end

  def paginate(resource)
    resource = resource.page(params[:page] || 1)
    if params[:per_page]
      resource = resource.per_page(params[:per_page])
    end

    resource
  end

  # File rails/activesupport/lib/active_support/security_utils.rb, line 11
  #secure_compare is a public class method of ActiveSupport::SecurityUtils since rails 4.2.0 http://api.rubyonrails.org/v4.2.0/classes/ActiveSupport/SecurityUtils.html
  private

	def secure_compare(a, b)
		return false unless a.bytesize == b.bytesize
		l = a.unpack "C#{a.bytesize}"
		res = 0
		b.each_byte { |byte| res |= byte ^ l.shift }
		res == 0
	end
end

#在 BaseController 里我们禁止了 CSRF token 和 cookies



