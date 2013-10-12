class Micropost < ActiveRecord::Base
	belongs_to :user
	#DESC is SQL for "descending"
	# scopes take an anonymous function that returns the criteria
	# desired for the scope. In this case order('...').
	#It is a lambda.
	default_scope -> { order('created_at DESC') }
	#Each micropost should have a user id
	validates :user_id, presence: true
	validates :content, presence: true, length: { maximum: 140 }
end
