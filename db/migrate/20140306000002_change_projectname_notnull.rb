class ChangeProjectnameNotnull < ActiveRecord::Migration
  def changecolumn
    change_column :projects, :project_name, :string, null: false
  end
end
