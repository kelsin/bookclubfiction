require 'rails_helper'

RSpec.describe ProfilesController, :type => :controller do
  before :each do
    @user = User.create(:uid => 5)
  end

  describe 'while logged in' do
    before :each do
      sign_in @user
    end

    describe '#show' do
      it 'responds with success' do
        get :show, :format => :json
        expect(response).to be_success
        expect(response).to render_template("profiles/show")
        expect(assigns[:user]).to eq(@user)
      end
    end
  end
end
