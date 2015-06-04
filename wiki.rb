require "sinatra/base"
require "sinatra/reloader"
require "pry"

require_relative './db/database'

module Wiki
	class Server < Sinatra::Base

		# SETTING UP REQUIREMENTS ----------------------------

		configure do 
			register Sinatra::Reloader
			set :sessions, true
		end #configure
		
		def current_user 
			session[:user_id]
		end	#current user	

		def user_login?
			if current_user == nil
				false
			else 
				true
			end	
		end	#user_login?

		# HOMEPAGE SETUP ----------------------------
		get '/' do 
		erb :index, layout: :layout
		end	#index

		# CREATING NEW USER ----------------------------

		get '/new_user' do 
			erb :new_user, layout: :layout
		end	

		post '/new_user' do 

			redirect '/'
		end


		# LOGIN SETUP
		post '/login' do 
			@password = params[:password]
			@email = params[:email]
			@user = $db.exec_params("SELECT * from users WHERE email = $1;", [@email]).first
			if @user['password'] == @password && @user['email'] == @email
				session[:user_id] = @user["id"]
				redirect "/profile/#{@user['fname']}"
			else 
				redirect '/notallowed'
			end		
		end

		delete '/login' do 
      session[:user_id] = nil
      redirect '/'
    end  


    # USER PROFILE SETUP AND EDITING ----------------------------

		get '/profile/:fname' do 
			@user = $db.exec_params("SELECT * from users WHERE id = $1;", [current_user]).first
			@id = @user['id']
			if params[:fname] != @user['fname']
				redirect '/notallowed'
			elsif user_login? == true
				erb :profile, layout: :layout
			end
		end	

		get '/notallowed' do  # user does not have acces to other people's profile pages
			erb :not_allowed, layout: :layout
		end

		post '/profile/update' do 
			@user = $db.exec_params("SELECT * from users 
				WHERE id = $1;", [current_user]).first

			if params[:password1] == @user["password"] && params[:password2] == ""
				$db.exec_params("UPDATE users SET fname=$1, lname=$2, email=$3, bio=$4 WHERE id =$5;", 
					[params[:fname], params[:lname], params[:email], params[:bio], current_user])
				redirect "/profile/#{params[:fname]}"		
			elsif 
				params[:password1] == @user["password"] && params[:password2] == params[:password3] 
				$db.exec_params("UPDATE users SET fname=$1, lname=$2, email=$3, password=$4, bio=$5 WHERE id =$6;", 
					[params[:fname], params[:lname], params[:email], params[:password2], params[:bio], current_user])
				redirect "/profile/#{params[:fname]}"
			end
		end	

		# SETTING UP ARTICLES ----------------------------

		get '/articles/new' do 
			@categories = $db.exec_params("SELECT * from categories;")
			if user_login? == false
				redirect '/notallowed'
			else 	
				erb :new_article, layout: :layout
			end	
		end 

		post '/articles/new/post' do 
			@categories_1 = params[:categories_1]
			@name_article = params[:name]
			@content = params[:content]

			result = $db.exec_params("INSERT INTO articles 
				(name, content,category_id, created_by, created_at,edited_on) 
				VALUES ($1,$2,$3,$4, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) 
				RETURNING id;", [@name_article, @content, @categories_1, current_user])
			redirect '/articles/all'
		end	


		get '/articles/all' do 
			@articles = $db.exec_params("SELECT * FROM articles")
			erb :articles, layout: :layout
		end

		get '/articles/:id' do 
			@article = $db.exec_params("SELECT articles.*, users.fname, users.lname 
				FROM articles JOIN users ON articles.created_by =  users.id
				WHERE articles.id = $1;", [params[:id]]).first

			@article_update = $db.exec_params("SELECT articles.updated_by, users.fname, users.lname 
				FROM articles JOIN users ON articles.updated_by =  users.id
				WHERE articles.id = $1;", [params[:id]]).first
			erb :article, layout: :layout
		end

		get '/articles/:id/update' do 
			@id = params[:id]
			@article = $db.exec_params("SELECT * FROM articles WHERE id=$1;", [@id]).first
			@categories = $db.exec_params("SELECT * from categories;")	
			erb :article_update, layout: :layout
		end

		post '/articles/:id/update' do 
			@id = params[:id]
			@name = params[:name]
			@content = params[:content]
		  $db.exec_params("UPDATE articles SET name=$1, content=$2, edited_on= CURRENT_TIMESTAMP, updated_by=$3 
				WHERE id=$4;", [@name, @content, current_user, @id])
			redirect "/articles/#{@id}"
		end


		# AUTHOR PROFILE FOR PUBLIC ----------------------------
		get '/user/:id' do 

		end	

	end # class
end #module		