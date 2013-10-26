class SwapsController < ApplicationController
	before_action :signed_in_user, only: [:create, :destroy, :update]

	def create
		@swap = current_user.swaps.build(swap_params)
		if @swap.save
			flash[:success] = "Swap created!"
			redirect_to root_url
		else
			@feed_items = []
			render 'static_pages/home'
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
