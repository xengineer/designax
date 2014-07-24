
class Users::SessionsController < Devise::SessionsController
  before_filter :authorize, :only => 'index'

  def index
    #@users = current_user.getUser
    @users = current_user
    print @users.to_s
    respond_to do |format|
      format.html
    end
  end

  def authorize
    if current_user.role == "admin" or current_user.role == "manager"
      redirect_to design_data_path
    end
  end
end
