class AddDeleteToDesignData < ActiveRecord::Migration
  def change
    add_column :design_data, :delflag, :boolean, default: false
  end
end
