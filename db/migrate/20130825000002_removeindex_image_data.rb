class RemoveindexImageData < ActiveRecord::Migration
  def change
    remove_index :image_data, :column => [:project_id, :file_name]
  end
end
