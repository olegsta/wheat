class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.string :title

      t.integer :user_id
      t.index :user_id

      t.json :position, default: {}

      t.timestamps null: false
    end
  end
end
