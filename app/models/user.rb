class User < ApplicationRecord
	validates :sUserID, presence: true, length: {maximum: 20}
end
