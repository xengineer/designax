class RenameMemoToCharaName < ActiveRecord::Migration
  def up
    rename_column :design_data, :memo, :chara_name
  end

  def down
    rename_column :design_data, :chara_name, :memo
  end
end
