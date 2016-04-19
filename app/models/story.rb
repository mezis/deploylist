class Story < ActiveRecord::Base
  belongs_to :deploy
  belongs_to :author, inverse_of: :stories

  validates :sha, :date, :deploy, presence: true

  def short_ref
    sha ? sha[0, 7] : ""
  end
end
