module Exceptions
  class BookClubFictionError < StandardError; end
  class DuplicateNomination < BookClubFictionError; end
end
