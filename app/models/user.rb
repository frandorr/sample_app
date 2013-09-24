class User < ActiveRecord::Base
	#before_save callback. Emails downcase to avoid problems with database
	before_save { self.email = email.downcase }	

	validates :name,  presence: true, length: { maximum: 50 }
	# /i = case insensitive, \A = begining of string, \z = match end of string
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]*[a-z\d\-]+\.[a-z]+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
  									uniqueness: { case_sensitive: false } 

  	#password:
  	has_secure_password #It gives a lot of features of passwords
	validates :password, length: { minimum: 6 }

end