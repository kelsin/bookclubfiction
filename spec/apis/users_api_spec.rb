require 'rails_helper'

RSpec.describe "Users Api", :type => :api do
  describe('#vote') do
    describe('as a member') do
      before(:each) do
        sign_in :member
        @vote_user = FactoryGirl.create(:user)
      end

      it('should not allow me to up the votes on a user') do
        post "/users/#{@vote_user.id}/vote"

        @vote_user.reload
        expect(last_response).to_not be_ok
        expect(@vote_user.extra_votes).to eql(5)
      end

      it('should not allow me to down the votes on a user') do
        delete "/users/#{@vote_user.id}/vote"

        @vote_user.reload
        expect(last_response).to_not be_ok
        expect(@vote_user.extra_votes).to eql(5)
      end
    end

    describe('as an admin') do
      before(:each) do
        sign_in :admin
      end

      describe('with a user that has 5 votes') do
        before(:each) do
          @vote_user = FactoryGirl.create(:user)
        end

        it('should allow me to up the votes on a user') do
          expect(@vote_user.extra_votes).to eql(5)

          post "/users/#{@vote_user.id}/vote"

          @vote_user.reload
          expect(last_response).to be_ok
          expect(@vote_user.extra_votes).to eql(6)
        end

        it('should allow me to down the votes on a user') do
          expect(@vote_user.extra_votes).to eql(5)

          delete "/users/#{@vote_user.id}/vote"

          @vote_user.reload
          expect(last_response).to be_ok
          expect(@vote_user.extra_votes).to eql(4)
        end
      end

      describe('with a user that has 0 votes') do
        before(:each) do
          @vote_user = FactoryGirl.create(:user, :extra_votes => 0)
        end

        it('should not bring the votes below 0') do
          expect(@vote_user.extra_votes).to eql(0)

          delete "/users/#{@vote_user.id}/vote"

          @vote_user.reload
          expect(last_response).to be_ok
          expect(@vote_user.extra_votes).to eql(0)
        end
      end
    end
  end
end
