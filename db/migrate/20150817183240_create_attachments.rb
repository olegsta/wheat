class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.integer :user_id
      t.integer :position_id
      t.string :file
      t.string :filename

      t.timestamps null: false
    end
  end
end
