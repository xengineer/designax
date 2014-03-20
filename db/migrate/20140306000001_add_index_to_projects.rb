class AddIndexToProjects < ActiveRecord::Migration
  def change
    add_index :projects, :project_name
  end
end
