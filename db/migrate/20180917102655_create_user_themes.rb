class CreateUserThemes < ActiveRecord::Migration[5.2]
  def change
    create_table :user_themes do |t|
      t.integer :user_id
      t.integer :theme_id
      t.timestamps null: false
    end
  end
end
