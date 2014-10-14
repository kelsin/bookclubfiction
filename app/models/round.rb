class Round
  include MongoMapper::Document

  # Keys
  key :state, String, :default => 'nominating'
  key :seconding_at, Time
  key :reading_at, Time
  key :closed_at, Time

  timestamps!

  many :nominations, :order => :created_at

  # Indexes
  Round.ensure_index :created_at
  Round.ensure_index [[:state, 1], [:created_at, 1]]

  scope :in_state, lambda { |state| where(:state => state) }

  # Validations
  validates :state, :inclusion => { :in => %w(nominating seconding reading closed) }

  # State Transitions
  def pump
    case self.state
    when 'nominating'
      self.state = 'seconding'
      self.seconding_at = Time.now
    when 'seconding'
      self.state = 'reading'
      self.reading_at = Time.now
    when 'reading'
      self.state = 'closed'
      self.closed_at = Time.now
    end
  end

  def nominating_at
    self.created_at
  end

  def nominated?
    !!self.seconding_at
  end

  def seconding?
    self.state == 'seconding'
  end

  def seconded?
    !!self.reading_at
  end

  def reading?
    self.state == 'reading'
  end

  def read?
    !!self.closed_at
  end

  def closed?
    self.state == 'closed'
  end

  # Query helpers
  def self.current
    Round.first(:order => :created_at.desc)
  end
end
