class User < ActiveRecord::Base

	#dependent: :destroy = when destroy user, destroy its microposts
	has_many :microposts, dependent: :destroy

	#before_save callback. 
	#Emails downcase to avoid problems with database
	before_save { self.email = email.downcase }	
	before_create :create_remember_token

	validates :name,  presence: true, length: { maximum: 50 }
	# /i = case insensitive, \A = begining of string, \z = match end of string
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
	 					
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
  									uniqueness: { case_sensitive: false } 

  	#password:
  	has_secure_password #It gives a lot of features of passwords
	validates :password, length: { minimum: 6 }

	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	def User.encrypt(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

	def feed
		# ? ensures that id is properly escaped before being included in the 
		#underlying SQL query (avoid SQL injection)
		Micropost.where("user_id = ?", id)
	end


	private

		def create_remember_token
			self.remember_token = User.encrypt(User.new_remember_token)
		end
end