require "sinatra/base"
require "sinatra/reloader"
require "pry"
require "redcarpet"

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

		
		# def markdown(text)
	

		# HOMEPAGE SETUP ----------------------------
		get '/' do 
			@articles = $db.exec_params("SELECT * FROM articles ORDER by created_at DESC")
			@users = $db.exec_params("SELECT * FROM users ORDER BY fname ASC;")
			@user = $db.exec_params("SELECT * from users WHERE id = $1;", [current_user]).first
		erb :index, layout: :layout
		end	#index

		# CREATING NEW USER ----------------------------

		get '/new_user' do 
			erb :new_user, layout: :layout
		end	

		post '/new_user' do 
			if params[:password1] == params[:password2] && params[:password1] != nil
				$db.exec_params("INSERT INTO users (fname,lname,email,password,bio) VALUES ($1, $2, $3, $4, $5);", [params[:fname], params[:lname], params[:email], params[:password1], params[:bio]])
				redirect '/'
			else 
				redirect '/notallowed'	
			end	
		end


		# LOGIN SETUP ----------------------------
		post '/login' do 
			@password = params[:password]
			@email = params[:email]
			@user = $db.exec_params("SELECT * from users WHERE email = $1;", [@email]).first
			if @user['password'] == @password && @user['email'] == @email
				session[:user_id] = @user["id"]
				# redirect "/profile/#{@user['fname']}"
				redirect '/'
			else 
				redirect '/notallowed'
			end		

		end

		delete '/login' do 
      session[:user_id] = nil
      redirect '/'
    end  


    # USER PROFILE SETUP AND EDITING ----------------------------

		# get '/profile/:fname' do 
		# 	@user = $db.exec_params("SELECT * from users WHERE fname = $1;", [params[:fname]]).first
		# 	if @user['id'] == current_user
		# 		erb :profile, layout: :layout
		# 	else
		# 		redirect '/notallowed'
		# 	end
		# end	

		get '/profile/:id' do 
			@user = $db.exec_params("SELECT * from users WHERE id = $1;", [params[:id]]).first
			if params[:id] == current_user
				erb :profile, layout: :layout
			else
				redirect '/notallowed'
			end
		end	

		get '/notallowed' do  # user does not have acces to other people's profile pages
			erb :not_allowed, layout: :layout
		end

		post '/profile/update' do 
			@user = $db.exec_params("SELECT * from users 
				WHERE id = $1;", [current_user]).first

			if params[:password1] == @user["password"] && params[:password2] == ""
				$db.exec_params("UPDATE users SET fname=$1, lname=$2, email=$3, bio=$4, picture=$5 WHERE id =$6;", 
					[params[:fname], params[:lname], params[:email], params[:bio], params[:picture], current_user])
				redirect "/profile/#{@user['id']}"		
			elsif 
				params[:password1] == @user["password"] && params[:password2] == params[:password3] 
				$db.exec_params("UPDATE users SET fname=$1, lname=$2, email=$3, password=$4, bio=$5, picture=$6 WHERE id =$7;", 
					[params[:fname], params[:lname], params[:email], params[:password2], params[:bio], params[:picture], current_user])
				redirect "/profile/#{@user['id']}"
			end
		end	

		# SETTING UP ARTICLES ----------------------------

		get '/articles/new' do 
			@categories = $db.exec_params("SELECT * from categories;")
			@user = $db.exec_params("SELECT * from users WHERE id = $1;", [current_user]).first
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
			@picture = params[:picture]
			@site = params[:site]

			result = $db.exec_params("INSERT INTO articles 
				(name, content,category_id, created_by, created_at,edited_on, site, picture) 
				VALUES ($1,$2,$3,$4, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, $5,$6) 
				RETURNING id;", [@name_article, @content, @categories_1, current_user,@site,@picture])
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
			@picture = params[:picture]
			@site = params[:site]
		  $db.exec_params("UPDATE articles SET name=$1, content=$2, edited_on= CURRENT_TIMESTAMP, updated_by=$3, picture=$4, site=$5
				WHERE id=$6;", [@name, @content, current_user, @picture, @site, @id])
			redirect "/articles/#{@id}"
		end


		# AUTHOR PROFILE FOR PUBLIC ----------------------------
		get '/author/:id' do 
			@id=params[:id]
			@user = $db.exec_params("SELECT * FROM users WHERE id=$1;", [@id]).first
			@arts_created = $db.exec_params("SELECT created_by,name,id FROM articles WHERE created_by= $1;", [@id])
			@arts_updated = $db.exec_params("SELECT updated_by,name,id FROM articles WHERE updated_by= $1;", [@id])
			erb :author_page, layout: :layout
		end	


		# ALL USERS ----------------------------
		get '/authors/all' do 
			@users = $db.exec_params("SELECT * FROM users ORDER BY fname ASC;")
			erb :authors, layout: :layout
		end	

		# CATEGORIES ----------------------------

		get '/categories' do 
			@categories = $db.exec_params("SELECT * FROM categories ORDER BY name ASC")
			erb :categories, layout: :layout
		end	

		get '/categories/:id' do 
			@id=params[:id]
			@category= $db.exec_params("SELECT * FROM categories WHERE id=$1;", [@id]).first
			@articles = $db.exec_params("SELECT * FROM articles WHERE category_id=$1;", [@id])
			erb :category, layout: :layout

		end	

		post '/category/new' do
			@cat_new = params[:newcat]
			$db.exec_params("INSERT INTO categories (name) VALUES ($1);", [@cat_new])
			redirect '/articles/new'
		end	


		not_found do
		  status 404
		  erb :notallowed, layout: :layout
		end

	end # class
end #module	


module ApplicationHelper
	def markdown(text)
		options = [:hard_wrap, :filter_html, :autolink, :no_intraemphasis]
		Redcarpet.new(text, options).to_html.html_safe
	end	
end		








