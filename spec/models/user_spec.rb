require 'rails_helper'

describe User do
  let!(:author)      { Author.create!(email: 'author@test.com', password: 'password', password_confirmation: 'password') }
  let!(:normal_user) { User.create!(email: 'user@test.com', password: 'password', password_confirmation: 'password') }

  describe '#author?' do
    it 'returns true if type is Author' do
      user = Author.new

      expect(user.author?).to eq true 
    end
  end

  describe '#admin?' do
    it 'return true if type is Admin' do
      user = Admin.new

      expect(user.admin?).to eq true 
    end
  end
  
  describe '#user?' do
    it 'return true if type is nil' do
      user = User.new

      expect(user.user?).to eq true 
    end
  end

  describe '#follow!' do
    it 'follows the given author' do
      normal_user.follow!(author)

      expect(normal_user.following).to include author
    end
  end
  
  describe '#unfollow!' do
    it 'unfollows the given author' do
      normal_user.follow!(author)
      normal_user.unfollow!(author)

      expect(normal_user.following).to_not include author
    end
  end

  describe '#followed?' do
    it 'returns true if the author is followed by the user' do
      normal_user.follow!(author)
      
      expect(normal_user.followed?(author)).to eq true 
    end
  end

  describe '#followable?' do
    it 'returns true if the author is followable by the current_user' do
      expect(author.followable?(normal_user)).to eq true 
    end
  end
end
