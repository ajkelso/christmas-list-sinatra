class User < ActiveRecord::Base
    has_secure_password
    has_many :lists
    has_many :items, through: :lists

    validates :email, :password, :username, :name, presence: :true
    validates_uniqueness_of :username, presence: {:message => "That username is already taken, please use another username."}
    validates_uniqueness_of :email, presence: {:message => "That email is already associated to another account. Please use another email."}
end