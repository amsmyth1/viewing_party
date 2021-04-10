require 'rails_helper'

describe PartyFriend, type: :model do
  describe "relationships" do
    it { should belong_to :party }
    it { should belong_to :user }
  end

  describe "class methods" do
    describe "::create_party(party_id, friends_id)" do
      it "creates records based on party_id and an array of friends ids" do
        user = User.create(email: 'fun@email.com', password: 'test')
        user2 = User.create!(email: 'a@email.com', password: '123')
        user3 = User.create!(email: 'b@email.com', password: '1234')
        user4 = User.create!(email: 'c@email.com', password: '456')
        friendship_1 = Friendship.create!(user_id: user.id, friend_id: user2.id)
        friendship_2 = Friendship.create!(user_id: user.id, friend_id: user3.id)
        friendship_3 = Friendship.create!(user_id: user.id, friend_id: user4.id)

         movie = Movie.create!(api_id: 550)
         party = Party.create!({
           movie_id: movie.id,
           movie_title: "FightClub",
           duration: 150,
           date: DateTime.now + 5,
           user_id: user.id}
         )

         pf1 = PartyFriend.create_party(party.id, [user2.id, user3.id, user4.id])

        expect(PartyFriend.all.count).to eq(3)
        expect(PartyFriend.first.party_id).to eq(party.id)
        expect(PartyFriend.first.user_id).to eq(user2.id)
      end
    end
    describe "::invited_parties(user_id)" do
      it "returns an array of parties that user is invited to" do
        user = User.create(email: 'fun@email.com', password: 'test')
        user2 = User.create!(email: 'a@email.com', password: '123')
        user3 = User.create!(email: 'b@email.com', password: '1234')
        user4 = User.create!(email: 'c@email.com', password: '456')
        friendship_1 = Friendship.create!(user_id: user.id, friend_id: user2.id)
        friendship_2 = Friendship.create!(user_id: user.id, friend_id: user3.id)
        friendship_3 = Friendship.create!(user_id: user.id, friend_id: user4.id)

         movie = Movie.create!(api_id: 550)
         movie2 = Movie.create!(api_id: 551)
         party = Party.create!({
           movie_id: movie.id,
           movie_title: "FightClub",
           duration: 150,
           date: DateTime.now + 5,
           user_id: user.id}
         )
         party2 = Party.create!({
           movie_id: movie2.id,
           movie_title: "FightClub",
           duration: 150,
           date: DateTime.now + 5,
           user_id: user.id}
         )

         pf1 = PartyFriend.create_party(party.id, [user2.id, user3.id, user4.id])
         pf2 = PartyFriend.create_party(party2.id, [user3.id, user4.id])

        expect(PartyFriend.invited_parties(user2.id)).to eq([party])
        expect(PartyFriend.invited_parties(user3.id)).to eq([party, party2])
        expect(PartyFriend.invited_parties(user4.id)).to eq([party, party2])
      end
    end
  end
end
