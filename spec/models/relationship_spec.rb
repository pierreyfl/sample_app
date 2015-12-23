require 'rails_helper'

describe Relationship do
  let!(:author)       { Author.create!(email: 'author@test.com', password: 'password', password_confirmation: 'password') }
  let!(:normal_user)  { User.create!(email: 'user@test.com', password: 'password', password_confirmation: 'password') }
  let!(:relationship) { Relationship.new }

  describe :validations do
    describe 'follower presence' do
      it 'passes if the follower is present' do
        relationship.follower = normal_user
        relationship.save
        expect(relationship.errors.full_messages).to_not include 'Follower can\'t be blank'
      end

      it 'fails if the follower is blank' do
        relationship.save
        expect(relationship.errors.full_messages).to include 'Follower can\'t be blank'
      end
    end
    
    describe 'followed presence' do
      it 'passes if the following is present' do
        relationship.followed = author 
        relationship.save
        expect(relationship.errors.full_messages).to_not include 'Followed can\'t be blank'
      end

      it 'fails if the followed is blank' do
        relationship.save
        expect(relationship.errors.full_messages).to include 'Followed can\'t be blank'
      end
    end
  end
end
