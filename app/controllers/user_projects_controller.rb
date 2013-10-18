# -*- encoding: utf-8 -*-

class UserProjectsController < ApplicationController
  # GET /user_projects
  # GET /user_projects.json
  def index
    @user_projects = UserProject.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_projects }
    end
  end

  # GET /user_projects/1
  # GET /user_projects/1.json
  def show
    @user_project = UserProject.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user_project }
    end
  end

  # GET /user_projects/new
  # GET /user_projects/new.json
  def new
    @user_project = UserProject.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_project }
    end
  end

  # GET /user_projects/1/edit
  def edit
    @user_project = UserProject.find(params[:id])
  end

  # POST /user_projects
  # POST /user_projects.json
  def create
    @user_project = UserProject.new(params[:user_project])

    respond_to do |format|
      if @user_project.save
        format.html { redirect_to @user_project, notice: 'User project was successfully created.' }
        format.json { render json: @user_project, status: :created, location: @user_project }
      else
        format.html { render action: "new" }
        format.json { render json: @user_project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /user_projects/1
  # PUT /user_projects/1.json
  def update
    @user_project = UserProject.find(params[:id])

    respond_to do |format|
      if @user_project.update_attributes(params[:user_project])
        format.html { redirect_to @user_project, notice: 'User project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_projects/1
  # DELETE /user_projects/1.json
  def destroy
    @user_project = UserProject.find(params[:id])
    @user_project.destroy

    respond_to do |format|
      format.html { redirect_to user_projects_url }
      format.json { head :no_content }
    end
  end
end
