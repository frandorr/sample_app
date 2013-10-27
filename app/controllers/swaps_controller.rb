class SwapsController < ApplicationController
	before_action :signed_in_user, only: [:create, :destroy, :update]

	def new
		#TODO: redirect_to login if user not signed in
		@swap = Swap.new
	end

	def create
		@swap = current_user.swaps.build(swap_params)
		if @swap.save
			flash[:success] = "Swap created!"
			redirect_to swaps_path
		else
			render 'static_pages/swaps'
		end
	end

	def destroy
	end

	def update
	end


	private

		def swap_params
			params.require(:swap).permit(:description, :offer, :want)
		end
end
