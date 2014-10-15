require 'rails_helper'

RSpec.describe "Selections Api", :type => :api do
  before(:each) do
    @book = FactoryGirl.create(:book)
  end

  describe('#delete') do
    describe('with a logged in member') do
      before(:each) do
        sign_in :member
      end

      describe('with a nominating round') do
        before(:each) do
          @selection = FactoryGirl.create(:selection, :user => @user)
          @round = @selection.round
        end

        it('should allow a selection to be deleted') do
          delete("/rounds/#{@round.id}/selections/#{@selection.id}")

          expect(last_response).to be_ok
          expect(last_response.body).to_not have_json_path('error')
          expect(Selection.all.count).to eql(0)
        end
      end

      describe('with a seconding round') do
        before(:each) do
          @selection = FactoryGirl.create(:selection, :user => @user)
          @round = @selection.round
          @round.progress
          @round.save
        end

        it('should not allow a selection to be deleted') do
          delete("/rounds/#{@round.id}/selections/#{@selection.id}")

          expect(last_response).to_not be_ok
          expect(last_response.body).to have_json_path('error')
        end
      end
    end
  end

  describe('#create') do
    describe('with a seconding round') do
      before(:each) do
        sign_in :member
        @round = FactoryGirl.create(:seconding_round)
      end

      it('should not allow a selection to be created') do
        post("/rounds/#{@round.id}/selections",
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

        it('should not create a selection') do
          post("/rounds/#{@round.id}/selections",
               { :book => @book }.to_json,
               "Content-Type" => "application/json")

          expect(last_response).to_not be_ok
        end
      end

      describe('with a logged in member') do
        before(:each) do
          sign_in :member
        end

        it('should create a selection') do
          post("/rounds/#{@round.id}/selections",
               { :book => @book }.to_json,
               "CONTENT_TYPE" => "application/json")

          expect(last_response).to be_ok
          expect(last_response.body).to be_json_eql(@book.title.to_json).at_path("round/selections/0/book/title")
          expect(Selection.first.round_id).to eq(@round.id)
        end

        it('should not allow two selections for the same book') do
          @other_selection = FactoryGirl.create(:selection,
                                                :round => @round,
                                                :book => @book,
                                                :user => @user)
          post("/rounds/#{@round.id}/selections",
               { :book => @book }.to_json,
               "CONTENT_TYPE" => "application/json")

          expect(last_response).to_not be_ok
          expect(last_response.body).to have_json_path("error")
        end
      end
    end
  end
end
