module Functions

	def login?
    if session[:username].nil?
      return false
    else
      return true
    end
  end

  def username
    return session[:username]
  end

	def create_user(params)
    password_salt = BCrypt::Engine.generate_salt
    password_hash = BCrypt::Engine.hash_secret(params[:password], password_salt)
    token = SecureRandom.urlsafe_base64(nil, false)

    if User.find_by(username: params[:username]) 
      flash[:signup] = "Sorry, that username already exists"
      redirect '/signup'
    elsif User.find_by(email: params[:email])
      flash[:signup] = "Sorry, that email already exists"
      redirect '/signup'
    else
      @users = User.new(username: params[:username], email: params[:email], password_salt: password_salt, password_hash: password_hash, activated: false, token: token)
    end

    if @users.save
      a = Pony.mail(:to => "#{params[:email]}", :from => 'sidegeeks@gmail.com', :headers => { 'Content-Type' => 'text/html' }, :subject => 'Germ Blog Confirmation Mail', :body => "Click <a href='http://localhost:9292/confirm/#{params[:username]}/#{token}'>here</a> to get <b>activated</b>")
      flash[:signup] = "Success, an activation email has been sent"
      redirect "/login"
    else
      flash[:error] = "There is some error with the database."
      redirect "/signup"
    end
  end

	def log_user_in(params)

    if User.exists?(username: params[:username])
      user = User.find_by(username: params[:username])
      password_hash = BCrypt::Engine.hash_secret(params[:password], user[:password_salt])

      if user.activated == false
        flash[:login] = "Check email for activation link"
        redirect "/login" 
      end

      if user[:password_hash] == password_hash
        session[:username] = params[:username]
        redirect '/'  
      else
        flash[:login] = "Oops, looks like your credentials didn't match"
        redirect "/login"
      end
    
    else
      flash[:login] = "Seems like you've entered the wrong details."
      redirect "/login"
    end
  end

    
  def check_login?
    return true if login?
    return false
  end
end