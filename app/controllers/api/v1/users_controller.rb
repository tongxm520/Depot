class Api::V1::UsersController < Api::V1::BaseController
  before_filter :authenticate_user!, only:[:update] 

  def show
    @user=User.find(params[:id])
  end

  def update
    @user=User.find(params[:id])
    #return api_error(status: 403) if !UserPolicy.new(current_user,@user).update?
    #pundit 提供了更简便的 authorize 方法为我们做权限认证的工作。
    authorize @user, :update?
    @user.update_attributes(update_params)
  end

  private
  def update_params
    params.require(:user).permit(:name)
  end
end


