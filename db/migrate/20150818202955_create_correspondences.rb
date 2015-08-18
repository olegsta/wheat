class CreateCorrespondences < ActiveRecord::Migration
  def change
    create_table :correspondences do |t|
      t.json :json_users
      t.json :json_positions

      t.string :correspondence_type
      t.index :correspondence_type

      t.timestamps null: false
    end
  end
end
