class ChangeCommentLengthInDesignData < ActiveRecord::Migration
  def change
    change_column :design_data, :design_comment, :string, :limit => 30000
    change_column :design_data, :corp_comment, :string, :limit => 30000
  end
end
