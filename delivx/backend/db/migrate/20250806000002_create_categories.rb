class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :name, null: false, index: { unique: true }
      t.text :description
      t.boolean :active, default: true
      
      t.timestamps
    end
  end
end
