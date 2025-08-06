class CreateRestaurants < ActiveRecord::Migration[7.0]
  def change
    create_table :restaurants do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description, null: false
      t.string :address, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.string :zip_code, null: false
      t.string :phone, null: false
      t.string :delivery_time, null: false
      t.decimal :delivery_fee, precision: 8, scale: 2, null: false
      t.decimal :minimum_order, precision: 8, scale: 2, null: false
      t.decimal :rating, precision: 3, scale: 2, default: 0
      t.boolean :active, default: true
      
      t.timestamps
    end
  end
end
