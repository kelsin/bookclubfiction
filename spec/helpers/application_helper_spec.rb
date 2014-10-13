require 'rails_helper'

RSpec.describe ApplicationHelper, :type => :helper do
  describe '#user_image' do
    it 'should generate an image link' do
      user = instance_double('User', :image => 'image_url')
      image = helper.user_image(user)
      expect(image).to have_selector(:css, 'img')
      expect(image).to match('image_url')
    end
  end
end
