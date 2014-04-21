class UserGroupsController < ApplicationController
  # GET /user_groups
  # GET /user_groups.json
  def index
    @user_groups = UserGroup.all
    @user_group = UserGroup.new

    print "###############:AAAAAAAAAAAAAAAA\n"
    print "###############:" + @user_groups[0].name + "\n"
    @user_groups[0].users do |user|
      puts user.user_name
      print "###############:" + user.user_name + "\n"
    end

    # index.html.haml表示用URL
    @urlroot = Designax::Application.config.urlroot

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_groups }
    end
  end

  # GET /user_groups/1
  # GET /user_groups/1.json
  def show
    @user_group = UserGroup.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user_group }
    end
  end

  # GET /user_groups/new
  # GET /user_groups/new.json
  def new
    @user_group = UserGroup.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_group }
    end
  end

  # GET /user_groups/1/edit
  def edit
    @user_group = UserGroup.find(params[:id])
  end

  # POST /user_groups
  # POST /user_groups.json
  def create
    @user_group = UserGroup.new(params[:user_group])

    respond_to do |format|
      if @user_group.save
        format.html { redirect_to @user_group, notice: 'User group was successfully created.' }
        format.json { render json: @user_group, status: :created, location: @user_group }
      else
        format.html { render action: "new" }
        format.json { render json: @user_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /user_groups/1
  # PUT /user_groups/1.json
  def update
    @user_group = UserGroup.find(params[:id])
    gname = params[:user_group]
    @user_group.name = gname

    respond_to do |format|
      #if @user_group.update_attributes(params[:user_group])
      if @user_group.save
        @user_groups = UserGroup.all
        #format.html { redirect_to @user_group, notice: 'User group was successfully updated.' }
        #format.html { redirect_to :action=>:index }
        format.html { render action: "index" }
        format.json { head :no_content }
      else
        @user_groups = UserGroup.all
        format.html { render action: "index" }
        format.json { render json: @user_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_groups/1
  # DELETE /user_groups/1.json
  def destroy
    @user_group = UserGroup.find(params[:id])
    @user_group.destroy

    respond_to do |format|
      format.html { redirect_to user_groups_url }
      format.json { head :no_content }
    end
  end
end
