class CreateCorrespondences < ActiveRecord::Migration
  def change
    create_table :correspondences do |t|
      t.integer :users_ids, array: true, default: []
      t.index :users_ids, using: 'gin'
      
      t.integer :positions_ids, array: true, default: []
      t.index :positions_ids, using: 'gin'

      t.json :json_users, default: []
      t.json :json_positions, default: []

      t.string :correspondence_type, default: 'users'
      t.index :correspondence_type

      t.timestamps null: false
    end
  end
end
