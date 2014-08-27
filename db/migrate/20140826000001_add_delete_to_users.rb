class AddDeleteToUsers < ActiveRecord::Migration
  def change
    add_column :users, :delflag, :boolean, default: false
  end
end
