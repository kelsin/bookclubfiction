class Selection
  include MongoMapper::Document

  belongs_to :user
  belongs_to :round
  one :book

  timestamps!

  # Scopes
  scope :by_round, lambda { |id| where(:round_id => id) }
  scope :by_user, lambda { |id| where(:user_id => id) }

  # Validations
  validates :user, :presence => true
  validates :round, :presence => true
  validates :book, :presence => true

  # Indexes
  Nomination.ensure_index [[:round_id, 1], [:created_at, 1]]
  Nomination.ensure_index [[:round_id, 1], [:user_id, 1], [:created_at, 1]]
end
