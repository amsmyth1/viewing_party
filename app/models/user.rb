class User < ApplicationRecord
  has_many :friendships
  has_many :friends, through: :friendships
  has_many :parties
  has_many :party_friends

  has_secure_password

  validates :email, uniqueness: true, presence: true
  validates :password, presence: true
  validates :password, confirmation: true

  enum role: %w(regular admin)
end
