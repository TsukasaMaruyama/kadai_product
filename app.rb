require 'bundler/setup'
Bundler.require
require 'sinatra/json'
require 'sinatra/reloader' if development?
require "./models"
require "date"
require 'bcrypt'
enable :sessions

before do
  if request.path != '/signin' && request.path != '/signup'
    if session[:user].nil?
      redirect '/signin'
    else
      @current_user = User.find(session[:user])
    end
  end
end

# 実質 /themes
get '/' do
  @themes = Theme.all
  @create_themes = @current_user.create_themes
  @users = User.all
  erb :index
end

post '/countup' do
  theme = Theme.find(params[:id])
  theme.count = theme.count + 1
  theme.save!
  theme_user = UserTheme.find_by(theme_id: theme.id, user_id: @current_user.id)
  if theme_user.nil?
    UserTheme.create(
        user_id: @current_user.id,
        theme_id: theme.id,
        count: 0
    )
  else
    theme_user.count = theme_user.count + 1
    theme_user.save!
  end
  redirect '/'
end

post '/ajax/countup' do
  theme = Theme.find(params[:id])
  theme.count = theme.count + 1
  theme.save!
  theme_user = UserTheme.find_by(theme_id: theme.id, user_id: @current_user.id)
  if theme_user.nil?
    UserTheme.create(
        user_id: @current_user.id,
        theme_id: theme.id,
        count: 0
    )
  else
    theme_user.count = theme_user.count + 1
    theme_user.save!
  end
  data = {count: theme.count}
  json data
end

get '/themes/detail/:id' do
  @theme = Theme.find(params[:id])
  erb :themes_detail
end

get '/users/mypage' do
  @create_themes = @current_user.create_themes
  erb :mypage
end

get '/users/edit' do
  erb :user_edit
end

post '/users/edit' do
  redirect '/users/mypage'
end

get '/themes/new' do
  erb :themes_new
end

post '/themes/new' do
  Theme.create(
      title: params[:title],
      description: params[:description],
      creator_id: session[:user],
      count: 0
  )
  redirect '/'
end

get '/signin' do
  erb :sign_in
end

post '/signin' do
  user = User.find_by(name: params[:name])
  if user && user.authenticate(params[:password])
    session[:user] = user.id
  end
  redirect '/'
end

get '/signup' do
  erb :sign_up
end

post '/signup' do
  user = User.create(
      name: params[:name],
      password: params[:password],
      password_confirmation: params[:password_confirmation]
  )
  session[:user] = user.id
  User.delete([name: "tsukasa.php@gmail.com"])
  redirect '/'
end

get '/signout' do
  session[:user] = nil
  redirect '/signin'
end

get '/search' do
  @theme = Theme.where('title like?','%'+params[:keyword]+'%' )
  erb :index
end

def image_upload(img)
  logger.info "upload now"
  tempfile = img[:tempfile]

  upload = Cloudinary::Uploader.upload(tempfile.path)

  contents = Contribution.last

  contents.update_attribute(:img, upload['url'])
end