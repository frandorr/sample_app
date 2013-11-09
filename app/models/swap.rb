class Swap < ActiveRecord::Base
	belongs_to :user
	default_scope -> { order('created_at DESC') }
	validates :user_id, presence: true
	validates :description, presence: true, length: { maximum: 140 }
	validates :offer, presence:true

	VALID_TAG_REGEX = /\A(\S+(,\s*)?)+\z/i

	# Tags:
	validates :tag_list, presence:true, format: { with: VALID_TAG_REGEX } 
	acts_as_taggable

	# Geocoder:
	geocoded_by :place
	after_validation :geocode

	def self.near_user_ip(user)
		Swap.near(user.ip_address)
	end
end
