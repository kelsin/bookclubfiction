class Nomination
  include MongoMapper::Document

  belongs_to :user
  belongs_to :round
  one :book
  key :admin, Boolean, :default => false

  key :vote_user_ids, Array
  key :extra_user_ids, Array

  many :votes, :in => :vote_user_ids, :class => User
  many :extras, :in => :extra_user_ids, :class => User

  timestamps!

  # Scopes
  scope :by_round, lambda { |id| where(:round_id => id) }
  scope :by_user, lambda { |id| where(:user_id => id) }

  # Validations
  validates :user_id, :presence => true
  validates :round_id, :presence => true
  validates :book, :presence => true
  validate :round_must_be_nominating, :on => :create
  validate :user_must_have_three_or_less_nominations
  validates_associated :votes
  validates_associated :extras

  # Indexes
  Nomination.ensure_index [[:round_id, 1], ['book.goodreads_id', 1]], :unique => true
  Nomination.ensure_index [[:round_id, 1], [:created_at, 1]]
  Nomination.ensure_index [[:round_id, 1], [:user_id, 1], [:created_at, 1]]

  def value
    self.vote_user_ids.size + self.extra_user_ids.size
  end

  def voted?(user)
    self.vote_user_ids.include? user.id
  end

  def extra?(user)
    self.extra_user_ids.include? user.id
  end

  def round_must_be_nominating
    unless round.nominating?
      errors.add(:round, 'is not currenting nominating')
    end
  end

  def user_must_have_three_or_less_nominations
    if !admin? && Nomination
        .by_round(self.round_id)
        .by_user(self.user_id)
        .where(:admin => false)
        .count >= 3
      errors.add(:user, 'already has 3 nominations')
    end
  end
end
