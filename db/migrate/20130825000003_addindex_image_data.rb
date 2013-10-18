class AddindexImageData < ActiveRecord::Migration
  def change
    add_index :image_data, [:project_id, :file_name, :seq_id], :unique => true
  end
end
