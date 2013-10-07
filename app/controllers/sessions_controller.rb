class SessionsController < ApplicationController
	def new
  end

 def create
  user = User.find_by(email: params[:session][:email].downcase)
  #any object other than nil is true. And user.authenticate becomes true
  #iff the password is correct
  if user && user.authenticate(params[:session][:password])
    # Sign the user in and redirect to the user's show page.
    sign_in user
    redirect_to user
  else
  	#we use flash.now because we want it to disappear when a new request is done.
  	#otherwise it stills there...
    flash.now[:error] = 'Invalid email/password combination' # Not quite right!
    render 'new'
  end
end

  def destroy
    #when user logout
    sign_out
    redirect_to root_url
  end
end
