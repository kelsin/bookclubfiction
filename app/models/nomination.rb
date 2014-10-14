class Nomination
  include MongoMapper::Document

  belongs_to :user
  belongs_to :round
  one :book
  many :votes

  timestamps!

  # Scopes
  scope :by_round, lambda { |id| where(:round_id => id) }
  scope :by_user, lambda { |id| where(:user_id => id) }

  # Validations
  validates :user, :presence => true
  validates :round, :presence => true
  validates :book, :presence => true

  # Indexes
  Nomination.ensure_index [[:round_id, 1], ['book.id', 1]], :unique => true
  Nomination.ensure_index [[:round_id, 1], [:created_at, 1]]
  Nomination.ensure_index [[:round_id, 1], [:user_id, 1], [:created_at, 1]]

  def value
    votes.sum &:value
  end
end
