class Vote
  include MongoMapper::EmbeddedDocument

  key :extra, Boolean
  belongs_to :user

  timestamps!

  # Validations
  validates :user_id, :presence => true
  validate :round_must_be_seconding, :on => :create

  def value
    self.extra ? 2 : 1
  end

  def nomination
    _root_document
  end

  def round_must_be_seconding
    if nomination
      unless nomination.round.seconding?
        errors.add(:base, 'Round is not currenting seconding')
      end
    end
  end
end
