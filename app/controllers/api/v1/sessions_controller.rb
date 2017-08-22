class Api::V1::SessionsController < Api::V1::BaseController
  
  def create
    @user=User.find_by_email(create_params[:email])
    if @user and User.authenticate(create_params[:email],create_params[:password])
      self.current_user=@user
    else
      return api_error(status: 401)
    end
  end

  private

  def create_params
    params.require(:user).permit(:email,:password)
  end
end
