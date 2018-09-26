require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require "./models"

require "bcrypt"

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
    erb :index 
end

get '/themes/detail/:id' do
    @theme = Theme.find(params[:id])
    @creator = @theme.creator
    erb :theme_detail
end

post '/themes/:id/plus' do
#   if request.xhr
       theme_id = params[:id]
       theme = Theme.find(theme_id)
       theme.count = theme.count + 1
       theme.save!
       theme_user = ThemeUser.find_by(user_id: session[:user], theme_id: theme_id)
       if theme_user
          theme_user.count = theme_user.count + 1
          theme_user.save!
        else
            ThemeUser.create(user_id: session[:user], theme_id: theme_id, count: 1)
       end
       redirect '/'
#   end
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
        password_confirmation: params[:password]
    )
    session[:user] = user.id
    redirect '/' 
end

get '/signout' do
    session[:user] = nil
    redirect '/sigin'
end