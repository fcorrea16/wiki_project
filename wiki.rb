require "sinatra/base"
require "sinatra/reloader"
require "pry"

require_relative './db/database'

module Wiki
	class Server < Sinatra::Base

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

		get '/' do 
		erb :index, layout: :layout
		end	#index

		post '/login' do 
			@password = params[:password]
			@email = params[:email]
			@author = $db.exec_params("SELECT * from authors WHERE email = $1;", [@email]).first
			if @author['password'] == @password && @author['email'] == @email
				session[:user_id] = @author["id"]
				redirect "/login/#{@author['fname']}"
			else 
				redirect '/notallowed'
			end		
		end

		delete '/login' do 
      session[:user_id] = nil
      redirect '/'
    end  

		get '/login/:fname' do 
			@author = $db.exec_params("SELECT * from authors WHERE id = $1;", [current_user]).first
			@id = @author['id']
			if params[:fname] != @author['fname']
				redirect '/notallowed'
			elsif user_login? == true
				erb :author_page, layout: :layout
			end
		end	

		get '/notallowed' do 
			erb :not_allowed, layout: :layout
		end

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
				(name, content,category_id, author_id,created_at,edited_on) 
				VALUES ($1,$2,$3,$4, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) RETURNING id;", [@name_article, @content, @categories_1, current_user])
			redirect '/articles/all'
		end	


		get '/articles/all' do 
			@articles = $db.exec_params("SELECT * FROM articles")
			erb :articles, layout: :layout
		end

		get '/articles/:id' do 
			@article = $db.exec_params("SELECT * from articles WHERE id=$1;", [params[:id]]).first
			erb :article, layout: :layout
		end

		post '/articles/:id/edit' do 

		end

	end # class
end #module		