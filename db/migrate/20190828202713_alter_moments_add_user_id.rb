class AlterMomentsAddUserId < ActiveRecord::Migration[5.2]
  def change
    add_column :moments, :user_id, :integer
    add_index :moments, :user_id
  end
end
