# -*- encoding: utf-8 -*-
require 'json'

class ProjectsController < ApplicationController
  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all

    # index.html.haml表示用URL
    @urlroot = Designax::Application.config.urlroot

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @project = Project.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.json
  def new
    @project = Project.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
  end

  # POST /projects
  # POST /projects.json
  def create
    @urlroot = Designax::Application.config.urlroot
    if params[:pk] == "new" and params[:name] == "project_name"
      project_name = params[:value]
      @project = Project.new()
      @project.project_name = project_name
    else
      @project = Project.new(params[:project])
    end

    respond_to do |format|
      if @project.save
        redirect_url = @urlroot + "/projects"
        response_url = { "url" => redirect_url }
        format.json { render json: response_url, status: 200 }
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.json
  def update
    @project = Project.find(params[:id])

    if params[:name] == "project_name"
      project_name = params[:value]
      @project.project_name = project_name
    end

    respond_to do |format|
      if @project.update_attributes(params[:project])

        @projects = Project.all
        format.html {
          render :action => "index"
        }
        format.json { render json: @project }
      else
        logMessage = self.class.to_s + "#" + __method__.to_s + " " + current_user.username + " errors:" + @project.errors.full_messages.to_s
        logger.info logMessage

        format.html {
          flash[:error] = 'Project was not successfully updated.'
          redirect_to action: "index"
        }
        errorMsg = @project.errors.full_messages.to_s.split("\"")
        format.json { render json: errorMsg[1], status: 500 }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end
end
