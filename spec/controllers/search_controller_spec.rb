require 'rails_helper'

RSpec.describe SearchController, :type => :controller do
  before :each do
    @user = User.create(:uid => 5)
  end

  describe 'while logged out' do
    before :each do
      sign_out :user
    end

    describe '#search' do
      it 'responds with error' do
        get :search, :q => 'test', :format => :json
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'while logged in' do
    before :each do
      sign_in @user
    end

    describe '#search' do
      it 'responds with error' do
        get :search, :q => 'test', :format => :json
        expect(response).to have_http_status(401)
      end
    end

    describe 'as an admin' do
      before :each do
        @user.set :admin => true
      end

      describe '#search' do
        it 'response with success' do
          client = double("client")
          expect(client).to receive(:search_books).and_return('results')
          expect(controller).to receive(:client).and_return(client)

          get :search, :q => 'test', :format => :json
          expect(response).to be_success
          expect(response).to render_template("search/search")
          expect(assigns[:response]).to eq('results')
        end
      end
    end

    describe 'as a member' do
      before :each do
        @user.set :member => true
      end

      describe '#search' do
        it 'response with success' do
          client = double("client")
          expect(client).to receive(:search_books).and_return('results')
          expect(controller).to receive(:client).and_return(client)

          get :search, :q => 'test', :format => :json
          expect(response).to be_success
          expect(response).to render_template("search/search")
          expect(assigns[:response]).to eq('results')
        end
      end
    end
  end
end
