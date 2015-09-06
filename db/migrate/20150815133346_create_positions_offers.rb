class CreatePositionsOffers < ActiveRecord::Migration
  def change
    create_table :positions_offers do |t|
      t.integer :position_id
      t.index :position_id

      t.integer :offer_id
      t.index :offer_id

      t.index [:offer_id, :position_id]

      t.string :status, default: "new"

      t.timestamps null: false
    end
  end
end
