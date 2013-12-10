# encoding: utf-8

require 'RMagick'

class DesignDatum < ActiveRecord::Base
  paginates_per 50
  belongs_to :project
  belongs_to :state
  belongs_to :corp_state
  has_many   :imagedatum
  attr_accessible :corp_comment, :ctype, :curSeq_id, :design_comment
  attr_accessible :designer, :file_name, :chara_name, :up_date, :thumbnail#, :curImage
  attr_accessible :state_id, :project_id, :corp_state_id, :deadline

  validates :file_name, :presence => {:message => " no file name."},
            :length => {:maximum => 30, :message => " file name too long."},
            :uniqueness => {:scope => :project_id, :message => " file name is already taken."}
            
  validates :ctype,
            :length => {:maximum => 100, :message => " ctype too long."}
  validates :design_comment,
            :length => {:maximum => 40960, :message => " designer's comment too long."}
  validates :corp_comment,
            :length => {:maximum => 40960, :message => " corporate side comment too long."}
  validates :designer,
            :presence => {:message => " no designer name."}
  validates :curSeq_id,
            :presence => {:message => " no current sequence id"},
            :numericality => {:only_integer => true, :greater_than => 0, :less_than => 50, :message => " wrong sequence id."}
  validates :state_id,
            :presence => {:message => "no state."},
            :numericality => {:only_integer => true, :greater_than => 0, :less_than => 9, :message => " wrong state."}
  validates :corp_state_id,
            :presence => {:message => "no corp_state or corp_state not right."},
            :numericality => {:only_integer => true, :greater_than => 0, :less_than => 4, :message => " wrong corp_state."}
  validates :project_id,
            :presence => {:message => "no project."},
            :numericality => {:only_integer => true, :greater_than => 0, :less_than => 1000, :message => " wrong project."}
  #validates_date :deadline, :after => :today

                 #:after_message => " must be set to future."

  validate :file_invalid?

  def setMembers(data, role)

    if data.thumbnail
      img                 = Magick::Image.from_blob(data.thumbnail.read)
      self.thumbnail      = img[0].thumbnail(0.3).to_blob
      self.ctype          = data.thumbnail.content_type
      data.thumbnail.rewind
    end

    self.corp_comment   = data.corp_comment   if data.corp_comment
    self.design_comment = data.design_comment if data.design_comment
    self.designer       = data.designer       if data.designer
    self.file_name      = data.file_name      if data.file_name
    self.chara_name     = data.chara_name     if data.chara_name
    self.up_date        = data.up_date        if data.up_date
    self.deadline       = data.deadline       if data.deadline
    self.curSeq_id      = data.curSeq_id      if data.curSeq_id

    self.state_id       = data.state_id       if data.state_id
    self.project_id     = data.project_id     if data.project_id

    if role == "artist"
      self.corp_state_id  = 1
    else
      self.corp_state_id  = data.corp_state_id  if data.corp_state_id
    end
    #image.rewind
  end

  def updateData(postedDesign, user, imageId, thumb)

    # 画像更新する場合は、レコード追加するパターン
    # なので、seq_idとかもインクリ
    if thumb
      image_datum = ImageDatum.new
      self.setImage(thumb)

      postedDesign.curSeq_id  = self.curSeq_id
      postedDesign.project_id = self.project_id
      image_datum.setAdditionalImage(thumb, self.file_name)
    # こっちは既存レコードの納期とか状態を更新する
    else
      postedDesign.project_id = self.project_id
      image_datum = ImageDatum.find(imageId)
    end

    # ファイル名変更時は全image_dataを変更する
    if self.file_name != postedDesign.file_name
      imgs = image_datum.getImagesByFileName()
      imgs.each do |img|
        img.file_name = postedDesign.file_name
      end
    else
      imgs = Array.new
    end

    image_datum.updateCommonAttr(postedDesign)
    self.setMembers(postedDesign, user.role)

    return [image_datum, imgs]
  end 

  #def getImagesByFileName()
  #  image = ImageDatum.new()
  #  image.file_name = self.file_name
  #  return image.getImagesByFileName()
  #end


  def setImage(imgdat)
    img                 = Magick::Image.from_blob(imgdat.read)
    self.thumbnail      = img[0].thumbnail(0.3).to_blob
    imgdat.rewind
    self.curSeq_id = self.curSeq_id + 1
  end

  def self.findIndexData(user, page, fltArtist, fltProject, fltState, fltCorpState, fltDelFlag)
    filter = ""

    if fltProject.blank?
      fltTempProject   = "project_id like ?"
    else
      fltTempProject   = "project_id = ?"
    end

    if fltState.blank?
      fltTempState     = "state_id like ?"
    else
      fltTempState     = "state_id = ?"
    end

    if fltCorpState.to_i == -2 and user.role == "admin"
      filter       = fltTempState + " and corp_state_id = ? and " + fltTempProject + " and delflag = ?"
      fltCorpState = "1"
    elsif fltCorpState.to_i == -2
      filter       = fltTempState + " and corp_state_id like ? and " + fltTempProject + " and delflag = ?"
      fltCorpState = "%"
    elsif fltState.blank? and fltCorpState.to_i == -1
      filter       = "not (state_id = ? and corp_state_id = ?) and " + fltTempProject + " and delflag = ?"
      fltState     = "8"
      fltCorpState = "2"
    elsif fltCorpState.to_i == -1
      filter       = fltTempState + " and corp_state_id like ? and " + fltTempProject + " and delflag = ?"
      fltCorpState = "%"
    else
      filter = fltTempState + " and corp_state_id like ? and " + fltTempProject + " and delflag = ?"
    end

    fltProject   = "%" if fltProject.blank?
    fltState     = "%" if fltState.blank?
    fltCorpState = "%" if fltCorpState.blank?

    if fltDelFlag == "true"
      fltDelFlag   = "1"
    else
      fltDelFlag   = "0"
    end

    case user.role
    when "artist"
      filter = filter + " and designer = ?"
      fltArtist = user.username
    when "manager", "admin"
      if !fltArtist.blank?
        filter = filter + " and designer = ?"
        designer = User.find(fltArtist);
        # エラー処理そのうち実装するかね・・・

        fltArtist = designer.username
      else
        filter = filter + " and designer like ?"
        fltArtist   = "%"
      end
    end
    design_data = DesignDatum.where(filter, fltState, fltCorpState, fltProject, fltDelFlag, fltArtist).order("deadline asc").page(page)

    return design_data
  end

  private
  def file_invalid?
    ps = ['image/jpeg']
    errors.add(:image, 'is not an image file') if !ps.include?(self.ctype)
    errors.add(:image, 'file size exceeds 1.5MB') if self.thumbnail.size > 1.5.megabyte
  end
end
