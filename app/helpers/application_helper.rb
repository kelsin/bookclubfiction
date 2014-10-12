module ApplicationHelper
  def user_image(user)
    image_tag user.image, :class => 'profile-img'
  end
end
