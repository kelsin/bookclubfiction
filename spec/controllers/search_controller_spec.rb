require 'rails_helper'

RSpec.describe SearchController, :type => :controller do
  before(:each) do
    @user = User.create(:uid => 5)
  end

  describe('while logged in') do
    before(:each) do
      sign_in @user
    end

    describe('#seach') do
      it 'responds with success' do
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
