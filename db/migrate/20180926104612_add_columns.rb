class AddColumns < ActiveRecord::Migration[5.2]
  def change
    add_column :user_themes, :count, :integer
  end
end
