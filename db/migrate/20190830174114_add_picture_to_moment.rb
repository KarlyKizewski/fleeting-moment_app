class AddPictureToMoment < ActiveRecord::Migration[5.2]
  def change
    add_column :moments, :picture, :string
  end
end
