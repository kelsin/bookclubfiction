require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController, :type => :controller do
  describe('#goodreads') do
    it "responds with success" do
      @user = User.new
      allow(User).to receive(:find_for_goodreads).and_return(@user)
      expect(controller).to receive(:sign_in_and_redirect)
      expect(controller).to receive(:set_flash_message)

      controller.goodreads
    end
  end
end
