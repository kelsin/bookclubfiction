class Round
  include MongoMapper::Document

  # Keys
  key :state, String, :default => 'nominating'
  key :seconding_at, Time
  key :reading_at, Time

  timestamps!

  many :nominations, :order => :created_at

  # Indexes
  Round.ensure_index(:created_at)

  # Validations
  validates :state, :inclusion => { :in => %w(nominating seconding reading) }

  # State Transitions
  def lock
    if self.state == 'nominating'
      self.state = 'seconding'
      self.seconding_at = Time.now
    end
  end

  def close
    if self.state == 'seconding'
      self.state = 'reading'
      self.reading_at = Time.now
    end
  end

  def nominating_at
    self.created_at
  end

  # Query helpers
  def self.current
    Round.first(:order => :created_at.desc)
  end
end
