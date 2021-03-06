require 'rails_helper'

RSpec.describe "Votes Api", :type => :api do
  describe('#vote') do
    before(:each) do
      @nomination = FactoryGirl.create(:nomination)
      @round = @nomination.round
    end

    describe('with a nominating round') do
      before(:each) do
        sign_in :member
      end

      it('should not allow me to create a vote') do
        post "/rounds/#{@round.id}/nominations/#{@nomination.id}/vote"

        @nomination.reload
        expect(last_response).to_not be_ok
        expect(@nomination.votes).to be_empty
        expect(@nomination.extras).to be_empty
        expect(@nomination.value).to eql(0)
      end

      it('should not allow me to create an extra') do
        post "/rounds/#{@round.id}/nominations/#{@nomination.id}/extra"

        @nomination.reload
        expect(last_response).to_not be_ok
        expect(@nomination.votes).to be_empty
        expect(@nomination.extras).to be_empty
        expect(@nomination.value).to eql(0)
      end
    end

    describe('with a reading round') do
      before(:each) do
        sign_in :member
        @round.progress
        @round.progress
        @round.save
      end

      it('should not allow me to create a vote') do
        post "/rounds/#{@round.id}/nominations/#{@nomination.id}/vote"

        @nomination.reload
        expect(last_response).to_not be_ok
        expect(@nomination.votes).to be_empty
        expect(@nomination.extras).to be_empty
        expect(@nomination.value).to eql(0)
      end

      it('should not allow me to create an extra') do
        post "/rounds/#{@round.id}/nominations/#{@nomination.id}/extra"

        @nomination.reload
        expect(last_response).to_not be_ok
        expect(@nomination.votes).to be_empty
        expect(@nomination.extras).to be_empty
        expect(@nomination.value).to eql(0)
      end
    end

    describe('with a closed round') do
      before(:each) do
        sign_in :member
        @round.progress
        @round.progress
        @round.progress
        @round.save
      end

      it('should not allow me to create a vote') do
        post "/rounds/#{@round.id}/nominations/#{@nomination.id}/vote"

        @nomination.reload
        expect(last_response).to_not be_ok
        expect(@nomination.votes).to be_empty
        expect(@nomination.extras).to be_empty
        expect(@nomination.value).to eql(0)
      end

      it('should not allow me to create an extra') do
        post "/rounds/#{@round.id}/nominations/#{@nomination.id}/extra"

        @nomination.reload
        expect(last_response).to_not be_ok
        expect(@nomination.votes).to be_empty
        expect(@nomination.extras).to be_empty
        expect(@nomination.value).to eql(0)
      end
    end

    describe('with a seconding round') do
      before(:each) do
        @round.progress
        @round.save
      end

      describe('not logged in') do
        it('should not allow me to create a vote') do
          post "/rounds/#{@round.id}/nominations/#{@nomination.id}/vote"

          @nomination.reload
          expect(last_response).to_not be_ok
          expect(@nomination.votes).to be_empty
          expect(@nomination.extras).to be_empty
          expect(@nomination.value).to eql(0)
        end

        it('should not allow me to create an extra') do
          post "/rounds/#{@round.id}/nominations/#{@nomination.id}/extra"

          @nomination.reload
          expect(last_response).to_not be_ok
          expect(@nomination.votes).to be_empty
          expect(@nomination.extras).to be_empty
          expect(@nomination.value).to eql(0)
        end
      end

      describe('while logged in') do
        before(:each) do
          sign_in :user
        end

        it('should not allow me to create a vote') do
          post "/rounds/#{@round.id}/nominations/#{@nomination.id}/vote"

          @nomination.reload
          expect(last_response).to_not be_ok
          expect(@nomination.votes).to be_empty
          expect(@nomination.extras).to be_empty
          expect(@nomination.value).to eql(0)
        end

        it('should not allow me to create an extra') do
          post "/rounds/#{@round.id}/nominations/#{@nomination.id}/extra"

          @nomination.reload
          expect(last_response).to_not be_ok
          expect(@nomination.votes).to be_empty
          expect(@nomination.extras).to be_empty
          expect(@nomination.value).to eql(0)
        end
      end

      describe('while logged in as a member') do
        before(:each) do
          sign_in :member
        end

        it('should allow me to create a vote') do
          post("/rounds/#{@round.id}/nominations/#{@nomination.id}/vote")

          @nomination.reload
          expect(last_response).to be_ok
          expect(@nomination.votes).to_not be_empty
          expect(@nomination.extras).to be_empty
          expect(@nomination.value).to eql(1)
        end

        it('should not allow me to create a duplicate vote') do
          @time = Date.today
          Timecop.freeze(@time) do
            post("/rounds/#{@round.id}/nominations/#{@nomination.id}/vote")
          end

          @nomination.reload
          expect(last_response).to be_ok
          expect(@nomination.votes).to_not be_empty
          expect(@nomination.extras).to be_empty
          expect(@nomination.value).to eql(1)
          expect(@nomination.votes[0]['created_at']).to eq(@time)

          post("/rounds/#{@round.id}/nominations/#{@nomination.id}/vote")

          @nomination.reload
          expect(last_response).to be_ok
          expect(@nomination.votes).to_not be_empty
          expect(@nomination.extras).to be_empty
          expect(@nomination.value).to eql(1)
          expect(@nomination.votes[0]['created_at']).to eq(@time)
        end

        it('should allow me to delete my vote') do
          post("/rounds/#{@round.id}/nominations/#{@nomination.id}/vote")

          @nomination.reload
          expect(last_response).to be_ok
          expect(@nomination.votes).to_not be_empty
          expect(@nomination.extras).to be_empty
          expect(@nomination.value).to eql(1)

          delete("/rounds/#{@round.id}/nominations/#{@nomination.id}/vote")

          @nomination.reload
          expect(last_response).to be_ok
          expect(@nomination.votes).to be_empty
          expect(@nomination.extras).to be_empty
          expect(@nomination.value).to eql(0)
        end

        it('should not allow me to delete an old vote') do
          Timecop.freeze(5.minutes.ago) do
            post("/rounds/#{@round.id}/nominations/#{@nomination.id}/vote")
          end

          @nomination.reload
          expect(last_response).to be_ok
          expect(@nomination.votes).to_not be_empty
          expect(@nomination.extras).to be_empty
          expect(@nomination.value).to eql(1)

          delete("/rounds/#{@round.id}/nominations/#{@nomination.id}/vote")

          @nomination.reload
          expect(last_response).to be_ok
          expect(@nomination.votes).to_not be_empty
          expect(@nomination.extras).to be_empty
          expect(@nomination.value).to eql(1)
        end

        it('should allow me to delete a non vote') do
          delete("/rounds/#{@round.id}/nominations/#{@nomination.id}/vote")

          @nomination.reload
          expect(last_response).to be_ok
          expect(@nomination.votes).to be_empty
          expect(@nomination.extras).to be_empty
          expect(@nomination.value).to eql(0)
        end

        it('should allow me to create an extra vote') do
          post("/rounds/#{@round.id}/nominations/#{@nomination.id}/extra")

          @user.reload
          expect(@user.extra_votes).to eql(4)

          @nomination.reload
          expect(last_response).to be_ok
          expect(@nomination.votes).to_not be_empty
          expect(@nomination.extras).to_not be_empty
          expect(@nomination.value).to eql(2)
        end

        it('should not allow me to create a duplicate extra vote') do
          @time = Date.today
          Timecop.freeze(@time) do
            post("/rounds/#{@round.id}/nominations/#{@nomination.id}/extra")
          end

          @user.reload
          expect(@user.extra_votes).to eql(4)

          @nomination.reload
          expect(last_response).to be_ok
          expect(@nomination.votes).to_not be_empty
          expect(@nomination.extras).to_not be_empty
          expect(@nomination.value).to eql(2)
          expect(@nomination.extras[0]['created_at']).to eq(@time)

          post("/rounds/#{@round.id}/nominations/#{@nomination.id}/extra")

          @user.reload
          expect(@user.extra_votes).to eql(4)

          @nomination.reload
          expect(last_response).to be_ok
          expect(@nomination.votes).to_not be_empty
          expect(@nomination.extras).to_not be_empty
          expect(@nomination.value).to eql(2)
          expect(@nomination.extras[0]['created_at']).to eq(@time)
        end

        it('should only allow me to create an extra vote if the user has an extra vote') do
          @user.set(:extra_votes => 0)

          post("/rounds/#{@round.id}/nominations/#{@nomination.id}/extra")

          @user.reload
          expect(@user.extra_votes).to eql(0)

          @nomination.reload
          expect(last_response).to_not be_ok
          expect(@nomination.votes).to be_empty
          expect(@nomination.extras).to be_empty
          expect(@nomination.value).to eql(0)
        end

        it('should allow me to delete an extra vote') do
          post("/rounds/#{@round.id}/nominations/#{@nomination.id}/extra")

          @user.reload
          expect(@user.extra_votes).to eql(4)

          @nomination.reload
          expect(last_response).to be_ok
          expect(@nomination.votes).to_not be_empty
          expect(@nomination.extras).to_not be_empty
          expect(@nomination.value).to eql(2)

          delete("/rounds/#{@round.id}/nominations/#{@nomination.id}/extra")

          @user.reload
          expect(@user.extra_votes).to eql(5)

          @nomination.reload
          expect(last_response).to be_ok
          expect(@nomination.votes).to_not be_empty
          expect(@nomination.extras).to be_empty
          expect(@nomination.value).to eql(1)
        end

        it('should not allow me to delete an old extra vote') do
          Timecop.freeze(6.minutes.ago) do
            post("/rounds/#{@round.id}/nominations/#{@nomination.id}/extra")
          end

          @user.reload
          expect(@user.extra_votes).to eql(4)

          @nomination.reload
          expect(last_response).to be_ok
          expect(@nomination.votes).to_not be_empty
          expect(@nomination.extras).to_not be_empty
          expect(@nomination.value).to eql(2)

          delete("/rounds/#{@round.id}/nominations/#{@nomination.id}/extra")

          @user.reload
          expect(@user.extra_votes).to eql(4)

          @nomination.reload
          expect(last_response).to be_ok
          expect(@nomination.votes).to_not be_empty
          expect(@nomination.extras).to_not be_empty
          expect(@nomination.value).to eql(2)
        end

        it('should create a normal vote with an extra vote') do
          expect(@nomination.votes).to be_empty
          expect(@nomination.extras).to be_empty
          expect(@nomination.value).to eql(0)

          post("/rounds/#{@round.id}/nominations/#{@nomination.id}/extra")

          @user.reload
          expect(@user.extra_votes).to eql(4)

          @nomination.reload
          expect(last_response).to be_ok
          expect(@nomination.votes).to_not be_empty
          expect(@nomination.extras).to_not be_empty
          expect(@nomination.value).to eql(2)

          delete("/rounds/#{@round.id}/nominations/#{@nomination.id}/extra")

          @user.reload
          expect(@user.extra_votes).to eql(5)

          @nomination.reload
          expect(last_response).to be_ok
          expect(@nomination.votes).to_not be_empty
          expect(@nomination.extras).to be_empty
          expect(@nomination.value).to eql(1)
        end

        it('should delete an extra vote with a normal vote') do
          expect(@nomination.votes).to be_empty
          expect(@nomination.extras).to be_empty
          expect(@nomination.value).to eql(0)

          post("/rounds/#{@round.id}/nominations/#{@nomination.id}/extra")

          @user.reload
          expect(@user.extra_votes).to eql(4)

          @nomination.reload
          expect(last_response).to be_ok
          expect(@nomination.votes).to_not be_empty
          expect(@nomination.extras).to_not be_empty
          expect(@nomination.value).to eql(2)

          delete("/rounds/#{@round.id}/nominations/#{@nomination.id}/vote")

          @user.reload
          expect(@user.extra_votes).to eql(5)

          @nomination.reload
          expect(last_response).to be_ok
          expect(@nomination.votes).to be_empty
          expect(@nomination.extras).to be_empty
          expect(@nomination.value).to eql(0)
        end
      end
    end
  end
end
