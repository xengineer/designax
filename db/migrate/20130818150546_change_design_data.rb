class ChangeDesignData < ActiveRecord::Migration
  def up
    change_column :design_data, :thumbnail, :binary, :limit => 10.megabyte
  end

  def down
    change_column :design_data, :thumbnail, :binary
  end
end
