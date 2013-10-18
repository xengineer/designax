class CreateCorpStates < ActiveRecord::Migration
  def change
    create_table :corp_states do |t|
      t.string :state

      t.timestamps
    end
  end
end
