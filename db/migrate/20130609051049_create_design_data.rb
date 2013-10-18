class CreateDesignData < ActiveRecord::Migration
  def change
    create_table :design_data do |t|
      t.belongs_to :project
      t.string :file_name
      t.integer :curSeq_id
      t.binary :thumbnail, :limit=>1.megabyte
      t.string :ctype
      t.date :up_date
      t.string :designer
      t.string :memo
      t.belongs_to :state
      t.belongs_to :corp_state
      t.string :design_comment
      t.string :corp_comment
      t.date :deadline

      t.timestamps
    end
    add_index :design_data, :project_id
    add_index :design_data, :state_id
    add_index :design_data, :corp_state_id
    add_index :design_data, [:project_id, :file_name], :unique => true
  end
end
