class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize, :only => 'index'

  def index
    @users = User.all
    print @users.to_s
    respond_to do |format|
      format.html
    end
  end

  def authorize
    if current_user.role.to_s == "admin"
      return true
    end
    redirect_to design_data_path
  end
end
