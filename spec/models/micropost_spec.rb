require 'rails_helper'

describe Micropost do
  let!(:author) { Author.create(email: 'author@test.com', password: 'password', password: 'password') }
  let!(:user)   { User.create(email: 'user@test.com', password: 'password', password: 'password') }

  describe :validations do
    describe 'user presence' do
      it 'passes if the user is present' do
        micropost = Micropost.new user: author 

        micropost.save
        expect(micropost.errors.full_messages).to_not include 'User can\'t be blank'
      end

      it 'fails if the user is blank' do
        micropost = Micropost.new user: nil
        
        micropost.save
        expect(micropost.errors.full_messages).to include 'User can\'t be blank'
      end
    end

    describe 'content presence' do
      it 'passes if the content is present' do
        micropost = Micropost.new user: author, content: 'test' 

        micropost.save
        expect(micropost.errors.full_messages).to_not include 'User can\'t be blank'
      end

      it 'fails if the content is blank' do
        micropost = Micropost.new user: author, content: nil
        
        micropost.save
        expect(micropost.errors.full_messages).to include 'Content can\'t be blank'
      end
    end

    describe 'user type' do
      it 'passes if the user is an Admin/Author' do
        micropost = Micropost.new(user: author, content: 'test')
        
        micropost.save
        expect(micropost.errors.full_messages).to_not include 'User cannot create post'
      end

      it 'fails if the user is a normal User' do
        micropost = Micropost.new(user: user, content: 'test')
        
        micropost.save
        expect(micropost.errors.full_messages).to include 'User cannot create post'
      end
    end
  end
end
