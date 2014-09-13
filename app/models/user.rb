class User
  include MongoMapper::Document

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :authenticatable, :omniauthable, :rememberable, :trackable, :omniauth_providers => [:goodreads]

  key :name, String
  key :username, String
  key :image, String
  key :location, String
  key :website, String
  key :about, String

  key :provider, String
  key :uid, String

  # Rememberable
  key :remember_created_at, Time

  # Trackable
  key :current_sign_in_at, Time
  key :current_sign_in_ip, String
  key :last_sign_in_at, Time
  key :last_sign_in_ip, String
  key :sign_in_count, Integer

  def self.find_for_goodreads(auth)
    user = User.find_or_create_by_provider_and_uid(auth.provider, auth.uid)

    # Update with any new info
    user.name = auth.info.name
    user.username = auth.info.user_name
    user.image = auth.info.image
    user.location = auth.info.location
    user.website = auth.info.website
    user.about = auth.info.about

    if user.changed?
      user.save
    end

    return user
  end
end
