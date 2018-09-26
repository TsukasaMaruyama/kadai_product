require 'bundler/setup'
Bundler.require

if development?
    ActiveRecord::Base.establish_connection("sqlite3:db/development.db")
end

class User < ActiveRecord::Base
    has_secure_password
    has_many :themes, through: :theme_users
    has_many :create_themes, class_name: "Theme", foreign_key: "creator_id"
end

class Theme < ActiveRecord::Base
    has_many :users, through: :theme_users
    belongs_to :creator, class_name: "User", foreign_key: "creator_id"
end

class ThemeUser < ActiveRecord::Base
    belongs_to :theme
    belongs_to :user
end

