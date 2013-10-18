# encoding: utf-8

require 'RMagick'

class ImageDatum < ActiveRecord::Base
  belongs_to :project
  belongs_to :designdatum
  belongs_to :state
  attr_accessible :file_name, :ctype, :image, :seq_id, :thumbnail, :up_date
  attr_accessible :designdatum_id, :state_id, :project_id, :delflag

  validates :file_name, :presence => true, :length => {:maximum => 30, :message => " file name is too long."}
  validates :ctype,
            :length => {:maximum => 100, :message => " ctype is too long."}
  validates :seq_id,
            :presence => true,
            :numericality => {:only_integer => true, :greater_than => 0, :less_than => 50},
            :uniqueness => {:scope => [:file_name, :project_id]}
  validates :state,
            :presence => true
  validates :project_id,
            :presence => {:message => " no project."},
            :numericality => {:only_integer => true, :greater_than => 0, :less_than => 1000, :message => " wrong project."}
  validates :project,
            :presence => true
  validates :image,
            :presence => true
            #:length => {:maximum => 15}


  validate :file_invalid?

  def setMembers(data)
    self.ctype     = data.thumbnail.content_type
    img            = Magick::Image.from_blob(data.thumbnail.read)
    self.image     = img[0].change_geometry('x400') {|cols, rows, image|
      image.resize!(cols, rows).to_blob
    }
    self.thumbnail = img[0].thumbnail(0.3).to_blob

    self.seq_id    = data.curSeq_id
    self.up_date   = data.up_date
    self.file_name = data.file_name || "" 
    self.project_id = data.project_id
    self.state_id   = data.state_id

    data.thumbnail.rewind
  end

  # imgdatをgeometry変更して imageとして設定して、
  # thumbnailにも設定する
  def setImage(imgdat)
    if imgdat
      self.ctype     = imgdat.content_type
      img            = Magick::Image.from_blob(imgdat.read)
      self.image     = img[0].change_geometry('x400') {|cols, rows, image|
        image.resize(cols, rows).to_blob
      }
      self.thumbnail = img[0].thumbnail(0.3).to_blob
    end
    imgdat.rewind
  end

  def updateMembers(data)

    self.seq_id     = data.curSeq_id if data.curSeq_id
    self.up_date    = data.up_date   if data.up_date
    self.file_name  = data.file_name if data.file_name
    self.project_id = data.project_id
    self.state_id   = data.state_id

  end

  def setDelFlag(delImageId, delDesignId)

    delImage = ImageDatum.find(delImageId)
    delImage.each {|image|
      print "@@@@@@@@@@@@@@@@@@@@image:" + image.file_name + "\n"
    }
  end

  def getCurrentImageByFileName(id)
    image = self.find_by_file_name_and_seq_id(self.file_name, id)
    return image
  end

  def getImagesByFileName()
    return self.find_all_by_file_name(self.file_name)
  end

  private
  def file_invalid?
    ps = ['image/jpeg', 'image/gif', 'image/png']
    errors.add(:image, 'is not an image file') if !ps.include?(self.ctype)
    errors.add(:image, 'image file size exceeds 5MB') if self.image.size > 5.megabyte
    errors.add(:image, 'thumbnail file size exceeds 5MB') if self.thumbnail.size > 5.megabyte
  end
end
