class AddindexDesignData < ActiveRecord::Migration
  def change
    #add_index :design_data, [:project_id, :file_name], :unique => true
  end
end
