require 'sinatra/base'
require "sinatra/activerecord"
require 'mysql2'


get "/" do
	@posts = Post.order("created_at DESC")
	erb :index
end

class Test < Sinatra::Base
	register Sinatra::ActiveRecordExtension

	

	get '/posts/new' do
		@title = "New Title"
		@post = Post.new
		erb :"posts/new"
	end

	post "/posts" do
	  @post = Post.new(params[:post])
	  if @post.save
	  	redirect "posts/#{@post.id}"
	  else
	    erb :"posts/new"
	  end
	end

	get '/posts/:id/edit' do
		@title = "Edit Form"
		@post = Post.find(params[:id])
		erb :"posts/edit"
	end
  

	post "/posts/:id" do
	  @post = Post.find(params[:id])
	  if @post.update_attributes(params[:post])
	    redirect "/posts/#{@post.id}"
	  else
	    erb :"posts/edit"
	  end
	end

	get "/posts/:id" do
  		@post = Post.find(params[:id])
  		@title = @post.title
  		erb :"posts/show"
	end
end

class Post < ActiveRecord::Base
end