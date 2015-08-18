class CreateCorrespondenceUsers < ActiveRecord::Migration
  def change
    create_table :correspondence_users do |t|
      t.integer :user_id
      t.integer :correspondence_id
      t.index :correspondence_id
      t.index :user_id

      t.timestamps null: false
    end
  end
end
