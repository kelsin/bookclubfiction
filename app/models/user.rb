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
  key :uid, Integer

  # Rememberable
  key :remember_created_at, Time

  # Trackable
  key :current_sign_in_at, Time
  key :current_sign_in_ip, String
  key :last_sign_in_at, Time
  key :last_sign_in_ip, String
  key :sign_in_count, Integer

  # OAuth
  key :access_token, String
  key :access_token_secret, String

  key :member, Boolean, :default => false
  key :admin, Boolean, :default => false

  def self.find_for_goodreads(auth)
    user = User.find_or_create_by_provider_and_uid(auth.provider, auth.uid.to_i)

    # Goodreads member info
    user.name = auth.info.name
    user.username = auth.info.user_name
    user.image = auth.info.image
    user.location = auth.info.location
    user.website = auth.info.website
    user.about = auth.info.about

    # Access token
    user.access_token = auth.credentials.token
    user.access_token_secret = auth.credentials.secret

    # Update membership status
    user.update_membership

    if user.changed?
      user.save
    end

    return user
  end

  def client
    consumer = OAuth::Consumer.new(Goodreads.configuration.merge({ :site => 'http://www.goodreads.com' }))
    token = OAuth::AccessToken.new(consumer,
                                   access_token,
                                   access_token_secret)
    Goodreads.new :oauth_token => token
  end

  def groups
    client.group_list(uid)
  end

  def update_membership
    if groups.group
      groups.group.each do |g|
        if g.id == "88207"
          self.member = true
        end
      end
    end

    group = client.group("88207-bookclubfiction")
    group.moderators.group_user.each do |u|
      if u.user.id == uid
        self.admin = true
      end
    end
  end
end
