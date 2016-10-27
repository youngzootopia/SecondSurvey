class User < ApplicationRecord
	validates :sUserID, presence: true, length: {maximum: 20}
	
	has_secure_password
	validates :password, presence: true
end
