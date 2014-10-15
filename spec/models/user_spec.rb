require 'rails_helper'

class User
  def self.find_or_create_by_provider_and_uid(provider, uid)
    super
  end
end

RSpec.describe User, :type => :model do
  before(:each) do
    @user = User.new(:uid => 5)
  end

  describe '#client' do
    it('should contain our goodreads setup') do
      client = @user.client
      expect(client.api_key).to eq(Goodreads.configuration[:api_key])
      expect(client.api_secret).to eq(Goodreads.configuration[:api_secret])
    end
  end

  describe '#find_for_goodreads' do
    before(:each) do
      @info = double('info')
      allow(@info).to receive(:name).and_return('name')
      allow(@info).to receive(:user_name).and_return('user_name')
      allow(@info).to receive(:image).and_return('image')
      allow(@info).to receive(:location).and_return('location')
      allow(@info).to receive(:website).and_return('website')
      allow(@info).to receive(:about).and_return('about')

      @cred = double('credentials')
      allow(@cred).to receive(:token).and_return('token')
      allow(@cred).to receive(:secret).and_return('secret')

      @auth = double('auth')
      allow(@auth).to receive(:provider).and_return('goodreads')
      allow(@auth).to receive(:uid).and_return('5')
      allow(@auth).to receive(:info).and_return(@info)
      allow(@auth).to receive(:credentials).and_return(@cred)

      allow(User).to receive(:find_or_create_by_provider_and_uid)
        .with('goodreads', 5)
        .and_return(@user)

      allow(@user).to receive(:update_membership)
    end

    it 'should update_membership' do
      expect(@user).to receive(:update_membership)
      User.find_for_goodreads(@auth)
    end

    it 'should return the user object' do
      result = User.find_for_goodreads(@auth)
      expect(result).to equal(@user)
    end

    describe 'when user changed' do
      before(:each) do
        expect(@user).to receive(:changed?).and_return(true)
      end

      it 'should save' do
        expect(@user).to receive(:save)
        User.find_for_goodreads(@auth)
      end
    end

    describe 'when user has not changed' do
      before(:each) do
        expect(@user).to receive(:changed?).and_return(false)
      end

      it 'should save' do
        expect(@user).to_not receive(:save)
        User.find_for_goodreads(@auth)
      end
    end
  end

  describe '#update_membership' do
    before(:each) do
      @user = User.new(:uid => 5)
      @group = double('group', :id => "88207")
      @groups = double('groups')
      @client = double('client')

      @bcf_group = double('bcf_group')
      allow(@bcf_group).to receive_message_chain(:moderators, :group_user => [])
      allow(@client).to receive(:group).and_return(@bcf_group)
      allow(@client).to receive(:group_list).and_return(@groups)

      allow(@user).to receive(:client).and_return(@client)
    end

    describe 'when user is a member' do
      before(:each) do
        allow(@groups).to receive(:group).and_return([@group])
      end

      it 'should set member to true' do
        @user.update_membership
        expect(@user.member).to be(true)
      end

      it 'should set admin to false' do
        @user.update_membership
        expect(@user.admin).to be(false)
      end

      describe 'when user is an admin' do
        before(:each) do
          bcf_user = double('bcf_user')
          allow(bcf_user).to receive_message_chain(:user, :id => 5)
          expect(@bcf_group).to receive_message_chain(:moderators, :group_user => [bcf_user])
        end

        it 'should set admin to true' do
          @user.update_membership
          expect(@user.admin).to be(true)
        end
      end
    end

    describe 'when user is not a member' do
      before(:each) do
        allow(@groups).to receive(:group).and_return([])
      end

      it 'should set member to false' do
        expect(@user.member).to be(false)
      end

      it 'should not check for admin status' do
        expect(@client).to_not receive(:group)
        @user.update_membership
        expect(@user.admin).to be(false)
      end
    end
  end
end
