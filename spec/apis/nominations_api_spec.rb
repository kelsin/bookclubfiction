require 'rails_helper'

RSpec.describe "Nominations Api", :type => :api do
  before(:each) do
    @book = FactoryGirl.create(:book)
  end

  describe('#create') do
    describe('with a seconding round') do
      before(:each) do
        sign_in :member
        @round = FactoryGirl.create(:seconding_round)
      end

      it('should not allow a nomination to be created') do
        post("/rounds/#{@round.id}/nominations",
             { :book => @book }.to_json,
             "CONTENT_TYPE" => "application/json")

        expect(last_response).to_not be_ok
        expect(last_response.body).to have_json_path('error')
      end
    end

    describe('with a nominating round') do
      before(:each) do
        @round = FactoryGirl.create(:round)
      end

      describe('with a logged in user') do
        before(:each) do
          sign_in :user
        end

        it('should not create a nomination') do
          post("/rounds/#{@round.id}/nominations",
               { :book => @book }.to_json,
               "Content-Type" => "application/json")

          expect(last_response).to_not be_ok
        end
      end

      describe('with a logged in member') do
        before(:each) do
          sign_in :member
        end

        it('should create a nomination') do
          post("/rounds/#{@round.id}/nominations",
               { :book => @book }.to_json,
               "CONTENT_TYPE" => "application/json")

          expect(last_response).to be_ok
          expect(last_response.body).to be_json_eql(false.to_json).at_path("round/nominations/0/admin")
          expect(last_response.body).to be_json_eql(@book.title.to_json).at_path("round/nominations/0/book/title")
          expect(last_response.body).to be_json_eql(0.to_json).at_path("round/nominations/0/value")
          expect(Nomination.first.round_id).to eq(@round.id)
        end

        it('should remove a selection for the same book') do
          post("/rounds/#{@round.id}/selections",
               { :book => @book }.to_json,
               "CONTENT_TYPE" => "application/json")

          expect(Selection.count).to eq(1)

          post("/rounds/#{@round.id}/nominations",
               { :book => @book }.to_json,
               "CONTENT_TYPE" => "application/json")

          expect(Selection.count).to eq(0)

          expect(last_response).to be_ok
          expect(last_response.body).to be_json_eql(false.to_json).at_path("round/nominations/0/admin")
          expect(last_response.body).to be_json_eql(@book.title.to_json).at_path("round/nominations/0/book/title")
          expect(last_response.body).to be_json_eql(0.to_json).at_path("round/nominations/0/value")
          expect(Nomination.first.round_id).to eq(@round.id)
        end

        it('should not allow an admin nomination to be created') do
          post("/rounds/#{@round.id}/nominations",
               { :book => @book,
                 :admin => true }.to_json,
               "CONTENT_TYPE" => "application/json")

          expect(last_response).to_not be_ok
          expect(last_response.body).to have_json_path('error')
        end

        it('should not allow two nominations for the same book') do
          @other_nomination = FactoryGirl.create(:nomination,
                                                 :round => @round,
                                                 :book => @book)

          post("/rounds/#{@round.id}/nominations",
               { :book => @book }.to_json,
               "CONTENT_TYPE" => "application/json")

          expect(last_response).to_not be_ok
          expect(last_response.body).to have_json_path("error")
        end

        it('should not allow over 3 nominations for the same user') do
          FactoryGirl.create(:nomination,
                             :user => @user,
                             :round => @round)
          FactoryGirl.create(:nomination,
                             :user => @user,
                             :round => @round)
          FactoryGirl.create(:nomination,
                             :user => @user,
                             :round => @round)

          expect(Nomination.by_round(@round.id).by_user(@user.id).where(:admin => false).count).to eql(3)

          post("/rounds/#{@round.id}/nominations",
               { :book => @book }.to_json,
               "CONTENT_TYPE" => "application/json")

          expect(last_response).to_not be_ok
          expect(last_response.body).to have_json_path("error")
          expect(Nomination.by_round(@round.id).by_user(@user.id).count).to eql(3)
        end
      end

      describe('with a logged in admin') do
        before(:each) do
          sign_in :admin
        end

        it('should allow the creation of an admin nomination') do
          post("/rounds/#{@round.id}/nominations",
               { :book => @book,
                 :admin => true }.to_json,
               "CONTENT_TYPE" => "application/json")

          expect(last_response).to be_ok
          expect(last_response.body).to be_json_eql(true.to_json).at_path("round/nominations/0/admin")
          expect(last_response.body).to be_json_eql(@book.title.to_json).at_path("round/nominations/0/book/title")
          expect(last_response.body).to be_json_eql(0.to_json).at_path("round/nominations/0/value")
          expect(Nomination.first.round_id).to eq(@round.id)
        end

        it('should allow over 3 admin nominations for the same user') do
          FactoryGirl.create(:nomination,
                             :user => @user,
                             :round => @round)
          FactoryGirl.create(:nomination,
                             :user => @user,
                             :round => @round)
          FactoryGirl.create(:nomination,
                             :user => @user,
                             :round => @round)

          expect(Nomination.by_round(@round.id).by_user(@user.id).where(:admin => false).count).to eql(3)

          post("/rounds/#{@round.id}/nominations",
               { :book => @book,
                 :admin => true }.to_json,
               "CONTENT_TYPE" => "application/json")

          expect(last_response).to be_ok
          expect(last_response.body).to be_json_eql(true.to_json).at_path("round/nominations/3/admin")
          expect(last_response.body).to be_json_eql(@book.title.to_json).at_path("round/nominations/3/book/title")
          expect(last_response.body).to be_json_eql(0.to_json).at_path("round/nominations/3/value")
          expect(Nomination.by_round(@round.id).by_user(@user.id).count).to eql(4)
        end
      end
    end
  end
end
