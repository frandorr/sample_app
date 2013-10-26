class SwapsController < ApplicationController
	before_action :signed_in_user, only: [:create, :destroy, :update]

	def create
	end

	def destroy
	end

	def update
	end
end
