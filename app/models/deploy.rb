class Deploy < ActiveRecord::Base
  has_many :stories, dependent: :destroy

  validates :uid, :sha, :username, :environment, :time, presence: true
  validates_uniqueness_of :uid

  scope :production, -> { where(environment: 'production') }
  scope :not_imported, -> { where(imported: false) }
  scope :not_missing, -> { where(missing_sha: false) }

  default_scope { order('time DESC') }

  def short_ref
    sha ? sha[0, 7] : ""
  end

  def previous
    @previous ||= Deploy.not_missing.where('time < ?', time).order(:time).first
  end
end
