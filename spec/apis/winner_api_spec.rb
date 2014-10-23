require 'rails_helper'

RSpec.describe "Winner Api", :type => :api do
  describe('#win') do
    describe('with a member') do
      before(:each) do
        sign_in :member
      end

      describe('with a non-winning nomination') do
        before(:each) do
          @nomination = FactoryGirl.create(:nomination)
          @round = @nomination.round
        end

        it('should not allow me to create a winner') do
          post "/rounds/#{@round.id}/nominations/#{@nomination.id}/win"

          @nomination.reload
          expect(last_response).to_not be_ok
          expect(@nomination.winner).to be false
        end
      end

      describe('with a winning nomination') do
        before(:each) do
          @nomination = FactoryGirl.create(:winning_nomination)
          @round = @nomination.round
        end

        it('should not allow me to delete a winner') do
          delete "/rounds/#{@round.id}/nominations/#{@nomination.id}/win"

          @nomination.reload
          expect(last_response).to_not be_ok
          expect(@nomination.winner).to be true
        end
      end
    end

    describe('with an admin') do
      before(:each) do
        sign_in :admin
      end

      describe('with a non-winning nomination') do
        before(:each) do
          @nomination = FactoryGirl.create(:nomination)
          @round = @nomination.round
        end

        it('should allow me to create a winner') do
          post "/rounds/#{@round.id}/nominations/#{@nomination.id}/win"

          @nomination.reload
          expect(last_response).to be_ok
          expect(last_response.body).to be_json_eql(true.to_json).at_path("round/nominations/0/winner")
          expect(@nomination.winner).to be true
        end
      end

      describe('with a winning nomination') do
        before(:each) do
          @nomination = FactoryGirl.create(:winning_nomination)
          @round = @nomination.round
        end

        it('should allow me to delete a winner') do
          delete "/rounds/#{@round.id}/nominations/#{@nomination.id}/win"

          @nomination.reload
          expect(last_response).to be_ok
          expect(last_response.body).to be_json_eql(false.to_json).at_path("round/nominations/0/winner")
          expect(@nomination.winner).to be false
        end
      end
    end
  end
end
