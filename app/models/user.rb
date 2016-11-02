class User < ApplicationRecord
  validates :sUserID, presence: true, length: {maximum: 20}
	
  has_secure_password
  validates :password, presence: true
	
  # Returns the hash digest of the given string.
  def User.digest(string)
	cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
	                                                  BCrypt::Engine.cost
	BCrypt::Password.create(string, cost: cost)
  end
  
  validates :birthday, presence: true
  validates :sex, presence: true
  validates :married, presence: true
  validates :children, presence: true
  validates :job, presence: true
  validates :hobby, presence: true
end
