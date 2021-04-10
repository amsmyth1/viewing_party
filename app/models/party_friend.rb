class PartyFriend < ApplicationRecord
  belongs_to :party
  belongs_to :user

  def self.create_party(party_id, friends_ids)
    friends_ids.map do |friend_id|
      PartyFriend.create!({party_id: party_id, user_id: friend_id})
    end
  end

  def self.invited_parties(user_id)
    Party.joins(:party_friends).where('party_friends.user_id = ?', user_id)
  end
end
