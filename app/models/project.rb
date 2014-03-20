# encoding: utf-8

class Project < ActiveRecord::Base
  attr_accessible :project_name

  validates :project_name,
            :presence => {:message => " no project_name."},
            :uniqueness => true
end
