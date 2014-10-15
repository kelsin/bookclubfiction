require 'rails_helper'

RSpec.describe "Rounds Api", :type => :api do
  describe('#create') do
    describe('not logged in') do
      it('should not allow me to create a round') do
        post '/rounds'

        expect(last_response).to_not be_ok
      end
    end

    describe('while logged in') do
      before(:each) do
        sign_in :user
      end

      it('should not allow me to create a round') do
        post '/rounds'

        expect(last_response).to_not be_ok
      end
    end

    describe('as a member') do
      before(:each) do
        sign_in :member
      end

      it('should not allow me to create a round') do
        post '/rounds'

        expect(last_response).to_not be_ok
      end
    end

    describe('as an admin') do
      before(:each) do
        sign_in :admin
      end

      it('should allow me to create a round') do
        post '/rounds'

        expect(last_response).to be_ok
        expect(Round.all).to_not be_empty
      end
    end
  end

  describe('#show') do
    describe('as a user') do
      before(:each) do
        sign_in :user
      end

      it('should not allow me to view a round') do
        @round = FactoryGirl.create(:round)

        get "/rounds/#{@round.id}"

        expect(last_response).to_not be_ok
      end
    end

    describe('as a member') do
      before(:each) do
        sign_in :member
      end

      it('should allow me to view a round') do
        @round = FactoryGirl.create(:round)

        get "/rounds/#{@round.id}"

        expect(last_response).to be_ok
        expect(last_response.body).to be_json_eql(@round.id.to_json).at_path("round/id")
        expect(last_response.body).to be_json_eql("nominating".to_json).at_path("round/state")
      end
    end
  end

  describe('#progress') do
    describe('as an admin') do
      before(:each) do
        sign_in :admin
      end

      describe('without a valid round') do
        it('should 404') do
          post '/rounds/234/progress'

          expect(last_response).to be_not_found
          expect(Round.all).to be_empty
        end
      end

      describe('with a valid nominating round') do
        before(:each) do
          @round = FactoryGirl.create(:round)
        end

        it('should progress the round to seconding') do
          post "/rounds/#{@round.id}/progress"

          expect(last_response).to be_ok

          @round.reload
          expect(@round).to be_seconding
        end
      end

      describe('with a valid seconding round') do
        before(:each) do
          @round = FactoryGirl.create(:seconding_round)
        end

        it('should progress the round to reading') do
          post "/rounds/#{@round.id}/progress"

          expect(last_response).to be_ok

          @round.reload
          expect(@round).to be_reading
        end
      end

      describe('with a valid reading round') do
        before(:each) do
          @round = FactoryGirl.create(:reading_round)
        end

        it('should progress the round to closed') do
          post "/rounds/#{@round.id}/progress"

          expect(last_response).to be_ok

          @round.reload
          expect(@round).to be_closed
        end
      end

      describe('with a valid closed round') do
        before(:each) do
          @round = FactoryGirl.create(:closed_round)
        end

        it('should do nothing to the round') do
          post "/rounds/#{@round.id}/progress"

          expect(last_response).to be_ok

          @round.reload
          expect(@round).to be_closed
        end
      end
    end
  end
end
