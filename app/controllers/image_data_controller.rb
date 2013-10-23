# -*- encoding: utf-8 -*-
#
require 'json'

class ImageDataController < ApplicationController
  # GET /image_data
  # GET /image_data.json
  def index
    @image_data = ImageDatum.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @image_data }
    end
  end

  # GET /image_data/1
  # GET /image_data/1.json
  def show
    @image_datum = ImageDatum.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @image_datum }
    end
  end

  def get_removeImages
    text = ""
    urlroot = Designax::Application.config.urlroot
    respond_to do |format|
      format.text {
        @design_data = DesignDatum.find(params[:id])
        @image_data  = ImageDatum.find_all_by_file_name(@design_data.file_name)
        lp = 1
        text = text + "<table class=\"tablemodaldel\">\n" + "<tbody>\n"
        @image_data.each { |image|
          if image.delflag == true
            checked = "checked"
          else
            checked = ""
          end
          text = text +
                  "<tr>\n"                              +
                  "  <td class=\"design_td2\">\n"       +
                  "    <div class=\"imagetiledel\">\n"  +
                  "      <div class=\"removeImage\">\n" +
                  "        <img alt=\"" + lp.to_s + "\" height=\"56px\" src=\"" + urlroot + "/image_data/thumbnail/" + image.id.to_s + "\" style=\"opacity: 0.7;\">\n" +
                  "      </div>\n" +
                  "      <span class=\"removeImageTxtTopLeft\"> デザイナー名 </span>" +
                  "      <span class=\"removeImageTxtTop\"> プロジェクト名 </span>" +
                  "      <span class=\"removeImageTxtTop\"> ステータス </span>" +
                  "      <span class=\"removeImageTxtTop\"> ファイル名 </span>" +
                  "      <span class=\"removeImageTxtTop\"> キャラ名 </span>" +
                  "      <span class=\"removeImageTxtTopRight\"> 削除フラグ </span>" +
                  "      <span class=\"removeImageTxtLeft\">" + @design_data.designer + "</span>" +
                  "      <span class=\"removeImageTxt\">" + @design_data.project.project_name + "</span>" +
                  "      <span class=\"removeImageTxt\">" + image.state.state + "</span>" +
                  "      <span class=\"removeImageTxt\">" + @design_data.file_name + "</span>" +
                  "      <span class=\"removeImageTxt\"> かわいい子 </span>" +
                  "      <span class=\"removeImageTxtRight\"><input name=\"delete[" + image.id.to_s + "]\" type=\"hidden\" value=\"0\" />" +
                  "      <input id=\"delete_\"" + image.id.to_s + "  name=\"delete[" + image.id.to_s + "]\" type=\"checkbox\" value=\"1\" " + checked+ "/></span>" +
                  "    </div>" +
                  "  </td>" +
                  "</tr>"

          lp = lp + 1
        }
        text = text + "</tbody>\n</table>\n"
        send_data(text.to_s, :type => 'text/plain', :disposition =>'inline')
      }
    end
  end

  def get_imagefiles
    text = ""
    urlroot = Designax::Application.config.urlroot
    design_data = DesignDatum.find(params[:id])
    #image_data  = ImageDatum.find_all_by_file_name(design_data.file_name)
    
    filter = "file_name = ? and delflag = ?"
    image_data = ImageDatum.where(filter, design_data.file_name, "0").order('seq_id desc')
    respond_to do |format|
      format.text {
        lp = 1
        image_data.each { |image|
          text = text + "<li>\n" +
                        "    <a display=\"block\" height=\"56px\" href=\"" + urlroot + "/image_data/image/" + image.id.to_s + "\">\n" +
                        "    <img alt=\"" + lp.to_s + "\" height=\"56px\" src=\"" + urlroot + "/image_data/thumbnail/" + image.id.to_s + "\" style=\"opacity: 0.7;\">\n" +
                        "  </a>\n" +
                        "</li>"
          lp = lp + 1
        }
        send_data(text.to_s, :type => 'text/plain', :disposition =>'inline')
      }
    end
  end

  def get_currentId
    text = ""
    respond_to do |format|
      format.text {
        @design_data = DesignDatum.find(params[:id])
        image_data  = ImageDatum.find_by_file_name_and_seq_id(@design_data.file_name, @design_data.curSeq_id)
        if image_data.nil?
          print "image_data wa nil dayo.\n"
        end
        text = image_data.id.to_s
        send_data(text.to_s, :type => 'text/plain', :disposition =>'inline')
      }
    end
  end

  def show_thumbnail
    @image_datum = ImageDatum.find(params[:id])
    send_data @image_datum.thumbnail, :type => @image_datum.ctype, :disposition => 'inline', :filename => 'thumbnail.jpg'
    #send_data @image_datum.image, :type => @image_datum.ctype, :disposition => 'inline'
  end

  def show_image
    @image_datum = ImageDatum.find(params[:id])
    send_data @image_datum.image, :type => @image_datum.ctype, :disposition => 'inline'
    #send_data @image_datum.image, :type => @image_datum.ctype, :disposition => 'inline'
  end

  # GET /image_data/new
  # GET /image_data/new.json
  def new
    @image_datum = ImageDatum.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @image_datum }
    end
  end

  # GET /image_data/1/edit
  def edit
    @image_datum = ImageDatum.find(params[:id])
  end

  # POST /image_data
  # POST /image_data.json
  def create
    @image_datum = ImageDatum.new(params[:image_datum])

    respond_to do |format|
      if @image_datum.save
        format.html { redirect_to @image_datum, notice: 'Image datum was successfully created.' }
        format.json { render json: @image_datum, status: :created, location: @image_datum }
      else
        format.html { render action: "new" }
        format.json { render json: @image_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /image_data/1
  # PUT /image_data/1.json
  #def update
  #  @image_datum = ImageDatum.find(params[:id])

  #  respond_to do |format|
  #    if @image_datum.update_attributes(params[:image_datum])
  #      format.html { redirect_to @image_datum, notice: 'Image datum was successfully updated.' }
  #      format.json { head :no_content }
  #    else
  #      format.html { render action: "edit" }
  #      format.json { render json: @image_datum.errors, status: :unprocessable_entity }
  #    end
  #  end
  #end
 
  # PUT /image_data/1
  # PUT /image_data/1.json
  def update
    delImageId = Array.new(0)
    updateIds = Hash.new

    # :delete sends hash of delete requested ids
    # ids are of ImageData(not DesignData)
    updateIds = params[:delete]

    updateImage = ImageDatum.find(updateIds.keys)

    # for later use
    # file name should be same in all updateImages
    # so it should be ok just to get from the 1st one
    file_name = updateImage[0].file_name

    # if the value is 1, set the delflag
    updateImage.each {|image|
      if updateIds[image.id.to_s] == "1"
        image.delflag = true
      else
        image.delflag = false
      end
      image.save!
    }

    # image_data上、最新のseq_idの画像を削除する場合、
    # design_dataのcurSeq_idは、削除されてないimage_dataのseq_idの
    # 一番大きいデータと同期してないといけないので、
    # その処理をする
    updateDesignData = DesignDatum.find_by_file_name(file_name)
    curSeq_id = updateDesignData.curSeq_id
    if updateIds.value?(0)
      recoverImage = ImageDatum.find_all_by_id_and_delflag(updateIds.keys, "0").order('seq_id DESC').limit(1)
      if curSeq_id != recoverImage.seq_id
        # image_dataの画像と、design_dataの画像は、thumbnailなら一緒！
        updateDesignData.thumbnail = recoverImage.thumbnail
        updateDesignData.curSeq_id = recoverImage.seq_id
        updateDesignData.save!
      end
    else
      updateDesignData.delflag = true
      updateDesignData.save!
    end

    respond_to do |format|
      format.html { redirect_to :controller => 'design_data', :action => 'index' }
      format.json { head :no_content }
    end
  end

  # DELETE /image_data/1
  # DELETE /image_data/1.json
  def destroy
    respond_to do |format|
      format.html { redirect_to :controller => 'design_data', :action => 'index' }
      format.json { head :no_content }
    end
  end
end
