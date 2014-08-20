require 'sinatra/base'
require "sinatra/activerecord"
require 'sinatra/flash'
require 'mysql2'
require 'rake'
require 'bcrypt'
require 'pony'
require './models'
require './functions'
require 'securerandom'


class App < Sinatra::Base

	register Sinatra::ActiveRecordExtension
	include Functions
  	enable :sessions
  	register Sinatra::Flash

	get "/" do
		if check_login?	
			@test = Test.order("id DESC")
			erb :tests_index
		else
			erb :home_layout, :layout => false
		end
	end

	# -------  User  --------------

	get '/login' do
		erb :login
	end

	get "/signup" do
    	erb :signup
  	end
   
	post "/signup" do
		create_user(params)
	end

	post "/login" do
    	log_user_in(params)
  	end

  	get "/confirm/:user/:token" do
		user = User.find_by(username: params[:user])
		if user.token == params[:token]
			user.update_attributes(activated: true)
			flash[:post] = "Successfully activated. Login!"
			session[:username] = user.username
			redirect '/'
		end
	end

  	get "/logout" do
	    session[:username] = nil
	    redirect "/"
  	end

	# -------  End User  --------------

	# -------  Start Questions  --------------

	get '/question/new' do
		redirect '/' if !check_login?
		@test = Test.order("id ASC")
		erb :new_question
	end

	post '/questions' do
		redirect '/' if !check_login?
		question = Question.new(question_title: params[:question])

		if params[:result] == "a"
			params[:result] = params[:a]
		elsif params[:result] == "b"
			params[:result] = params[:b]
		elsif params[:result] == "c"
			params[:result] = params[:c]
		elsif params[:result] == "d"
			params[:result] = params[:d]
		else
			params[:result] = "no result"
		end

		answers = Answer.new(a: params[:a], b: params[:b], c: params[:c], d: params[:d], result: params[:result])
		answers.question = question
		question.test = Test.find(params[:test_id])
		if question.save
			answers.save
	  		redirect "/"
	    else
	    	erb :error
	  	end
	end

	# -------  End Questions  --------------

	# -------  Start Tests  --------------

	get '/test/new' do
		redirect '/' if !check_login?
		erb :new
	end

	post "/tests" do
		redirect '/' if !check_login?
		test = Test.new(test_name: params[:test_name])
		user = User.where(username: session[:username]).first
		test.user = user
	    if test.save
	  		redirect "/"
	    else
	    	erb :new
	  	end
	end

	get "/test/:test_id" do
		redirect '/' if !check_login?
		@test = Test.find(params[:test_id])
		if Question.exists?(test_id: params[:test_id])
			@questions = Question.where(test_id: params[:test_id])
			erb :show
			#redirect "/#{@questions[@counter][:test_id]}/#{@counter}"
		else
			"no"
		end
	end

	post "/results/:test_id" do

		score_pass = 3

		questions = Question.where(test_id: params[:test_id])
		user = User.find_by(username: session[:username])
		test = Test.find(params[:test_id])
		result = Result.create(score: 0)
		result_id = result.id
		score = result.score
		result.user = user
		result.test = test
		result.save

		questions.each do |question|
			if question.answers.first.result == params["answer#{question.id}"]
				score = score + 1
				Result.update(result.id, score: score)
			else

			end
			
		end
		result = Result.find(result_id)
		@score = result.score
		if @score > 2
			erb :result
		else
			erb :failure
		end
		#erb :show
		#a = Question.count_by_sql "SELECT COUNT(*) FROM questions WHERE result > 0"
		#{}"score = #{a}"

	end

	get "/:test_id/:question_id" do

		@question = Question.find_by(id: params[:question_id])
		"#{@question}"
	end

	# -------  End Tests  --------------
end