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

  def self.get_imagefiles(id)
    text = ""
    urlroot = Designax::Application.config.urlroot
    design_data = DesignDatum.find(id)
    
    filter = "file_name = ? and delflag = ?"
    image_data = ImageDatum.where(filter, design_data.file_name, "0").order('seq_id desc')
    lp = 1
    image_data.each { |image|
      text = text + "<li>\n" +
                    "    <a display=\"block\" height=\"56px\" href=\"" + urlroot + "/image_data/image/" + image.id.to_s + "\">\n" +
                    "    <img alt=\"" + lp.to_s + "\" height=\"56px\" src=\"" + urlroot + "/image_data/thumbnail/" + image.id.to_s + "\" style=\"opacity\\: 0.7;\">\n" +
                    "  </a>\n" +
                    "</li>"
      lp = lp + 1
    }
    return text
  end

  def self.get_currentId(id)
    design_data = DesignDatum.find(id)
    image_data  = ImageDatum.find_by_file_name_and_seq_id(design_data.file_name, design_data.curSeq_id)
    if image_data.nil?
      print "image_data wa nil dayo.\n"
      return -1
    end
    text = image_data.id.to_s
    return text
  end

  def setMembers(data)
    self.ctype     = data.thumbnail.content_type
    img            = Magick::Image.from_blob(data.thumbnail.read)
    self.image     = img[0].to_blob
    self.thumbnail = img[0].thumbnail(0.3).to_blob

    self.seq_id    = data.curSeq_id
    self.up_date   = data.up_date
    self.file_name = data.file_name || "" 
    self.project_id = data.project_id
    self.state_id   = data.state_id

    data.thumbnail.rewind
  end

  def updateMembers(data)

    self.seq_id     = data.curSeq_id if data.curSeq_id
    self.up_date    = data.up_date   if data.up_date
    self.file_name  = data.file_name if data.file_name
    self.project_id = data.project_id
    self.state_id   = data.state_id

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
    ps = ['image/jpeg']
    errors.add(:image, 'is not an image file') if !ps.include?(self.ctype)
    errors.add(:image, 'image file size exceeds 1.5MB') if self.image.size > 1.5.megabyte
    errors.add(:image, 'thumbnail file size exceeds 1.5MB') if self.thumbnail.size > 1.5.megabyte
  end
end
