class CreateFavoritePositions < ActiveRecord::Migration
  def change
    create_table :favorite_positions do |t|
      t.integer :user_id
      t.integer :position_id

      t.timestamps null: false
    end
  end
end
