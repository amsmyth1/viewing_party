class Party < ApplicationRecord
  belongs_to :movie
  belongs_to :user

  has_many :party_friends
  has_many :friendships, through: :party_friends

  validates_numericality_of :duration, greater_than: 0
  validates_presence_of :date
  validates_presence_of :duration

  def host
    User.find(self.user_id)
  end
  def host_email
    (User.find(self.user_id)).email
  end
end
