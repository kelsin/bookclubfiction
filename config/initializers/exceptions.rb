module Exceptions
  class BookClubFictionError < StandardError; end
  class DuplicateNomination < BookClubFictionError; end
  class RoundStateError < BookClubFictionError; end
end
