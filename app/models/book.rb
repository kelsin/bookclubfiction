class Book
  include MongoMapper::EmbeddedDocument

  key :goodreads_id, Integer
  key :title, String
  key :rating, Float
  key :author, String
  key :image, String
  key :small_image, String

  def url
    return "https://www.goodreads.com/book/show/#{self.goodreads_id}"
  end

  validates :title, :presence => true
  validates :goodreads_id, :presence => true
  validates :goodreads_id, :numericality => { :only_integer => true }
  validates :rating, :numericality => true
end
