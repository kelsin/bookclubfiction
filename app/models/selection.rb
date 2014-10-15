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
  validates :user_id, :presence => true
  validates :round_id, :presence => true
  validates :book, :presence => true
  validate :round_must_be_nominating, :on => :create

  # Indexes
  Selection.ensure_index [[:round_id, 1], [:user_id, 1], ['book.goodreads_id', 1]], :unique => true
  Selection.ensure_index [[:round_id, 1], [:created_at, 1]]
  Selection.ensure_index [[:round_id, 1], [:user_id, 1], [:created_at, 1]]

  def round_must_be_nominating
    unless round.nominating?
      errors.add(:round, 'is not currenting nominating')
    end
  end
end
