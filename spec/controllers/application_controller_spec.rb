require 'rails_helper'

RSpec.describe ApplicationController, :type => :controller do
  before(:each) do
    @env = double("env")
    allow(@env).to receive(:[]).with('omniauth.origin').and_return('request')

    @request = double("request")
    allow(@request).to receive(:env).and_return(@env)

    allow(controller).to receive(:request).and_return(@request)
  end

  describe '#after_sign_in_path_for' do
    describe 'with request omniauth.origin' do
      it 'responds with success' do
        result = controller.after_sign_in_path_for('resource')
        expect(result).to eq('request')
      end
    end

    describe 'with stored_location_for' do
      before(:each) do
        expect(@env).to receive(:[]).and_return(nil)
        expect(controller).to receive(:stored_location_for)
          .with('resource')
          .and_return('stored')
      end

      it 'responds with success' do
        result = controller.after_sign_in_path_for('resource')
        expect(result).to eq('stored')
      end
    end

    describe 'with root_path' do
      before(:each) do
        expect(@env).to receive(:[]).and_return(nil)
        expect(controller).to receive(:stored_location_for)
          .with('resource')
          .and_return(nil)
        expect(controller).to receive(:root_path).and_return('root_path')
      end

      it 'responds with success' do
        result = controller.after_sign_in_path_for('resource')
        expect(result).to eq('root_path')
      end
    end
  end

  describe '#client' do
    it 'should contain our goodreads setup' do
      client = controller.client
      expect(client.api_key).to eq(Goodreads.configuration[:api_key])
      expect(client.api_secret).to eq(Goodreads.configuration[:api_secret])
    end
  end
end
