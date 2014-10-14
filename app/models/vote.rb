class Vote
  include MongoMapper::EmbeddedDocument

  key :extra, Boolean
  belongs_to :user

  timestamps!

  # Validations
  validates :user, :presence => true

  def value
    self.extra ? 2 : 1
  end
end