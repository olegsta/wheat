class AddImagesToPositions < ActiveRecord::Migration
  def change
    add_column :positions, :images, :json
  end
end
