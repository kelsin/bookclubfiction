class Round
  include MongoMapper::Document

  # Keys
  key :state, String, :default => 'nominating'
  key :created_at, Time

  # Indexes
  Round.ensure_index(:created_at)

  # State Transitions
  def lock
    if self.state == 'nominating'
      self.state = 'seconding'
    end
  end

  def close
    if self.state == 'seconding'
      self.state = 'reading'
    end
  end

  # Query helpers
  def self.current
    Round.first(:order => :created_at.desc)
  end
end
