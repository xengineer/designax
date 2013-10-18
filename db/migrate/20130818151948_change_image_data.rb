class ChangeImageData < ActiveRecord::Migration
  def change
    add_index :image_data, [:project_id, :file_name], :unique => true
  end

  def up
    change_column :image_data, :thumbnail, :binary, :limit => 10.megabyte
    change_column :image_data, :image, :binary, :limit => 10.megabyte
  end

  def down
    change_column :image_data, :thumbnail, :binary
    change_column :image_data, :image, :binary
  end
end

