class UsersController < ApplicationController
  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id]) # it'll return the user id
  end


  def create
    @user = User.new(user_params) #user params is defined as private (strong)
    if @user.save
    	#user signin after signup
    	sign_in @user
    	redirect_to @user
    	flash[:success] = "Welcome #{@user.name}!"
    else
      render 'new'
    end
  end


  #Strong parameters. To avoid malicious attacks, permited params should be
  # literally known. It's private, because we didn't want it to be available
  # in Web 

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
