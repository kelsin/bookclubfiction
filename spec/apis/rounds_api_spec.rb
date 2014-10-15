require 'rails_helper'

RSpec.describe "Rounds Api", :type => :api do
  before :each do
    clear_cookies
  end

  describe('not logged in') do
    it('should not allow me to create a round') do
      post '/rounds'

      expect(last_response).to_not be_ok
    end
  end

  describe('while logged in') do
    before(:each) do
      VCR.use_cassette('user', :record => :new_episodes) do
        sign_in :user
      end
    end

    it('should not allow me to create a round') do
      post '/rounds'

      expect(last_response).to_not be_ok
    end
  end

  describe('as a member') do
    before(:each) do
      VCR.use_cassette('member', :record => :new_episodes) do
        sign_in :member
      end
    end

    it('should not allow me to create a round') do
      post '/rounds'

      expect(last_response).to_not be_ok
    end
  end

  describe('as an admin') do
    before(:each) do
      VCR.use_cassette('admin', :record => :new_episodes) do
        sign_in :admin
      end
    end

    it('should allow me to create a round') do
      post '/rounds'

      expect(last_response).to be_ok
      expect(Round.all).to_not be_empty
    end
  end
end
