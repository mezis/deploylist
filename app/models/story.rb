class Story < ActiveRecord::Base
  belongs_to :deploy
  belongs_to :author, inverse_of: :stories

  validates :sha, :date, :deploy, presence: true

end
