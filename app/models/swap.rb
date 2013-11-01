class Swap < ActiveRecord::Base
	belongs_to :user
	default_scope -> { order('created_at DESC') }
	validates :user_id, presence: true
	validates :description, presence: true, length: { maximum: 140 }
	validates :offer, presence:true
	:tag_list
	acts_as_taggable
end
