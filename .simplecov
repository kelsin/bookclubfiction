require 'coveralls'

SimpleCov.start 'rails' do
  formatter SimpleCov::Formatter::MultiFormatter[SimpleCov::Formatter::HTMLFormatter, Coveralls::SimpleCov::Formatter]
  minimum_coverage 0
end
