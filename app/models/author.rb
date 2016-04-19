class Author < ActiveRecord::Base
  has_many :stories

  validates_presence_of :email
end
