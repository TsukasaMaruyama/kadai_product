class CreateThemes < ActiveRecord::Migration[5.2]
  def change
    create_table :themes do |t|
      t.string :title
      t.text :description
      t.integer :count
      t.text :image_url
      t.integer :creator_id
      t.timestamps null: false
    end
  end
end
