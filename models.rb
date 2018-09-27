require 'bundler/setup'
Bundler.require

if development?
  ActiveRecord::Base.establish_connection("sqlite3:db/development.db")
end

class User < ActiveRecord::Base
  validates :name, uniqueness: true
  has_secure_password
  has_many :user_themes
  has_many :themes, through: :user_themes
  has_many :create_themes, class_name: "Theme", foreign_key: "creator_id"
end

class Theme < ActiveRecord::Base
  has_many :user_themes
  has_many :users, through: :user_themes, class_name: "User", foreign_key: "user_id"
  belongs_to :creator, class_name: "User", foreign_key: "creator_id"
end

class UserTheme < ActiveRecord::Base
  belongs_to :theme
  belongs_to :user
end

