require 'rails_helper'

RSpec.describe ApplicationHelper, :type => :helper do
  describe "#user_image" do
    it "should generate an image link" do
      user = instance_double("User", :image => 'image')
      expect(helper.user_image(user)).to eql("<img alt=\"Image\" class=\"profile-img\" src=\"/images/image\" />")
    end
  end
end
