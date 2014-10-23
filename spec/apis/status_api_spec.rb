require 'rails_helper'

RSpec.describe "Status Api", :type => :api do
  describe('#status') do
    describe('not logged in') do
      it('should allow me to view status') do
        get '/status'

        expect(last_response).to be_ok
        expect(last_response.body).to_not have_json_path("user")
      end
    end

    describe('while logged in') do
      before(:each) do
        sign_in :user
      end

      it('should allow me to view status') do
        get '/status'

        expect(last_response).to be_ok
        expect(last_response.body).to have_json_path("user")
        expect(last_response.body).to be_json_eql(false.to_json).at_path("user/member")
        expect(last_response.body).to be_json_eql(false.to_json).at_path("user/admin")
      end
    end

    describe('as a member') do
      before(:each) do
        sign_in :member
      end

      it('should allow me to view status') do
        get '/status'

        expect(last_response).to be_ok
        expect(last_response.body).to have_json_path("user")
        expect(last_response.body).to be_json_eql(true.to_json).at_path("user/member")
        expect(last_response.body).to be_json_eql(false.to_json).at_path("user/admin")
      end
    end

    describe('as an admin') do
      before(:each) do
        sign_in :admin
      end

      it('should allow me to view status') do
        get '/status'

        expect(last_response).to be_ok
        expect(last_response.body).to have_json_path("user")
        expect(last_response.body).to be_json_eql(true.to_json).at_path("user/member")
        expect(last_response.body).to be_json_eql(true.to_json).at_path("user/admin")
      end
    end
  end
end
