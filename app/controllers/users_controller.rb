# coding: utf-8

class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize, :only => ['index', 'edit', 'update', 'destroy']

  def index
    @users_active   = User.where(["delflag = ?", '0'])
    @users_disabled = User.where(["delflag = ?", '1'])

    respond_to do |format|
      format.html
    end
  end

  def edit
    @user = User.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def update
    @user = User.find(params[:id])
    posted_user = params[:user]
    new_password = posted_user[:new_password]
    password_confirmation = posted_user[:password_confirmation]
    role = posted_user[:role]

    respond_to do |format|
      if new_password != password_confirmation
        format.html { redirect_to users_path, :alert => 'confirmation password が一致しません.' }
      end

      if @user.update_attributes(:password => new_password, :role => role)
        format.html { redirect_to users_path, notice: 'Password was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "index" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(:delflag => 'true')
        format.html { redirect_to users_path, notice: "Account #{@user.username} was successfully disabled." }
        format.json { head :no_content }
      else
        format.html { render action: "index" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def authorize
    if current_user.role.to_s == "admin"
      return true
    end
    redirect_to design_data_path
  end
end
