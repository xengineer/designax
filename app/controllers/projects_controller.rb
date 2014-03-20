# -*- encoding: utf-8 -*-

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
    if params[:pk] == "new" and params[:name] == "project_name"
      project_name = params[:value]
      @project = Project.new()
      @project.project_name = project_name
    else
      @project = Project.new(params[:project])
    end

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render json: @project, status: :created, location: @project }
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.json
  def update
    logger.debug "################################ update ##################################\n"
    @project = Project.find(params[:id])
    logger.debug "################################" + @project.project_name.to_s + "##################################\n"

    if params[:name] == "project_name"
      project_name = params[:value]
      @project.project_name = project_name
    end

    respond_to do |format|
      if @project.update_attributes(params[:project])
        logger.debug "################################ success ##################################\n"
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        logger.debug "################################ fail ##################################\n"
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
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
