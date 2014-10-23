class Nomination
  include MongoMapper::Document

  belongs_to :user
  belongs_to :round
  one :book
  key :admin, Boolean, :default => false
  key :winner, Boolean, :default => false

  key :votes, Array
  key :extras, Array

  timestamps!

  # Scopes
  scope :by_round, lambda { |id| where(:round_id => id) }
  scope :by_user, lambda { |id| where(:user_id => id) }
  scope :not_by_user, lambda { |id| where(:user_id.ne => id) }
  scope :winner, where(:winner => true)

  # Validations
  validates :user_id, :presence => true
  validates :round_id, :presence => true
  validates :book, :presence => true
  validate :round_must_be_nominating, :on => :create
  validate :user_must_have_three_or_less_nominations, :on => :create

  # Indexes
  Nomination.ensure_index [[:round_id, 1], ['book.goodreads_id', 1]], :unique => true
  Nomination.ensure_index [[:round_id, 1], [:created_at, 1]]
  Nomination.ensure_index [[:round_id, 1], [:user_id, 1], [:created_at, 1]]

  def value
    self.votes.size + self.extras.size
  end

  def vote(user)
    if user
      self.votes.detect do |vote|
        vote['id'] == user.id
      end
    end
  end

  def voted?(user)
    !!vote(user)
  end

  def vote_created_at(user)
    vote(user).try(:[], 'created_at').try(:to_i)
  end

  def extra(user)
    if user
      self.extras.detect do |extra|
        extra['id'] == user.id
      end
    end
  end

  def extra?(user)
    !!extra(user)
  end

  def extra_created_at(user)
    extra(user).try(:[], 'created_at').try(:to_i)
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
