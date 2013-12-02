# encoding: utf-8

require 'RMagick'
require 'json'

class DesignDataController < ApplicationController

  before_filter :authenticate_user!

  # GET /design_data
  # GET /design_data.json
  def index

    @users = current_user.getUser()
    @fltArtist    = params[:filterArtist]
    @fltCorpState = params[:filterCorpState]
    @fltState     = params[:filterState]
    @fltProject   = params[:filterProject]
    @fltDelFlag   = params[:filterDelete]
    page          = params[:page]

    @design_data = DesignDatum::findIndexData(current_user, page, @fltArtist, @fltProject, @fltState, @fltCorpState, @fltDelFlag)

    # index.html.haml表示用URL
    @urlroot = Designax::Application.config.urlroot

    # 新規投稿用空モデル
    @design_datum = DesignDatum.new

    # collection_selectデータ用
    @states = State.all
    @corp_states = CorpState.all
    @projects = Project.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @design_data }
    end
  end

  # GET /design_data/1
  # GET /design_data/1.json
  def show
    id = params[:id]

    col = "state_id, corp_state_id, corp_comment, design_comment, file_name, deadline, chara_name"
    @design_datum = DesignDatum.where(["id = ?", id]).select(col).first
    json_data = JSON.parse(@design_datum.to_json)
    json_data['role'] = current_user.role

    respond_to do |format|
      format.html # show.html.erb
      format.json {
        render json: json_data
      }
    end
  end

  # GET /design_data/1
  # GET /design_data/1.json
  def show_image
    @design_datum = DesignDatum.find(params[:id])
    fname = @design_datum.file_name + '.jpg'
    send_data @design_datum.image,     :type => @design_datum.ctype, :disposition => 'attachment', :filename => fname
  end

  def show_thumbnail
    @design_datum = DesignDatum.find(params[:id])
    fname = @design_datum.file_name + '_t.jpg'
    send_data @design_datum.thumbnail, :type => @design_datum.ctype, :disposition => 'attachment', :filename => fname
  end

  def get_designdata
    @design_datum = DesignDatum.find(params[:id])

    respond_to do |format|
      format.json { render json: @design_datum }
    end
  end

  # GET /design_data/new
  # GET /design_data/new.json
  def new
    @design_datum = DesignDatum.new
    @states = State.all
    @corp_states = CorpState.all
    @projects = Project.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @design_datum }
    end
  end

  # GET /design_data/1/edit
  def edit
    @design_datum = DesignDatum.find(params[:id])
    @states = State.all
    @corp_states = CorpState.all
    @projects = Project.all
  end

  # POST /design_data
  # POST /design_data.json
  def create
    d = DesignDatum.new(params[:design_datum])
    d.curSeq_id = 1
    d.corp_state_id = 1

    @image_datum = ImageDatum.new()
    @image_datum.setMembers(d)
    @design_datum = DesignDatum.new()
    @design_datum.setMembers(d, current_user.role)

    respond_to do |format|
      if @design_datum.save and @image_datum.save
        logMessage = self.class.to_s + "#" + __method__.to_s + " " + current_user.username +
                     " " + @design_datum.designer + " " + @design_datum.file_name + " " + @design_datum.deadline.to_s

        logger.info logMessage
        format.html { redirect_to :action=>:index, :notice=>'Design datum was successfully created.' }
        format.json { render json: @design_datum, status: :created, location: @design_datum }
      else
        logMessage = self.class.to_s + "#" + __method__.to_s + " " + current_user.username + " errors:" + @design_datum.errors.full_messages.to_s + " " + @image_datum.errors.full_messages.to_s
        logger.error logMessage

        flash[:error] = []
        flash[:error] = flash[:error] + @design_datum.errors.full_messages if not @design_datum.errors.empty?
        flash[:error] = flash[:error] + @image_datum.errors.full_messages  if not @image_datum.errors.empty?

        @design_datum.destroy
        @image_datum.destroy

        format.html { redirect_to :action=>:index }
        format.json { render json: @design_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /design_data/1
  # PUT /design_data/1.json
  def update
    @design_datum = DesignDatum.find(params[:id])
    postedDesign = DesignDatum.new(params[:design_datum])
    thumb     = params[:thumbnail]
    #id        = params[:id]
    imageId   = params[:image_data_id]

    @image_datum, imgs = @design_datum.updateData(postedDesign, current_user, imageId, thumb)

    respond_to do |format|
      begin
        ActiveRecord::Base.transaction() do
          @design_datum.save!
          @image_datum.save!
          imgs.each do |img|
            img.save!
          end
        end
        format.html { redirect_to action: "index" }
        format.json { head :no_content }
      rescue => e
        flash[:error] = "Data update failed : " + e.message
        flash[:error] = flash[:error] + @design_datum.errors.full_messages if not @design_datum.errors.empty?
        flash[:error] = flash[:error] + @image_datum.errors.full_messages  if !@image_datum.errors.empty?
        format.html { redirect_to :action=>:index }
      end
    end
  end

  # DELETE /design_data/1
  # DELETE /design_data/1.json
  def destroy
    @design_datum = DesignDatum.find(params[:id])
    @design_datum.destroy

    respond_to do |format|
      format.html { redirect_to design_data_url }
      format.json { head :no_content }
    end
  end
end
