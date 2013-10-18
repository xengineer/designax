class CreateImageData < ActiveRecord::Migration
  def change
    create_table :image_data do |t|
      t.belongs_to :project
      t.belongs_to :designdata_id
      t.integer :seq_id
      t.binary :image, :limit=>1.megabyte
      t.string :ctype
      t.string :file_name
      t.binary :thumbnail, :limit=>1.megabyte
      t.date :up_date
      t.belongs_to :state

      t.timestamps
    end
    add_index :image_data, :project_id
    add_index :image_data, :designdata_id_id
    add_index :image_data, :state_id
    #add_index :image_data, [:project_id, :file_name], :unique => true
  end
end
