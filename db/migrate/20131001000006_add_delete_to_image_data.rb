class AddDeleteToImageData < ActiveRecord::Migration
  def change
    add_column :image_data, :delflag, :boolean, default: false
  end
end
