class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :restaurant, null: false, foreign_key: true
      t.decimal :total_amount, precision: 8, scale: 2, null: false
      t.string :delivery_address, null: false
      t.integer :status, default: 0
      t.integer :rating
      t.text :observation
      
      t.timestamps
    end
  end
end
