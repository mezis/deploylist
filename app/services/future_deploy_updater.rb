# Creates or updates a fake "future deploy" containing
# whatever's in the master branch, but not deployed yet.
class FutureDeployUpdater
  include GithubClient

  def call
    deploy = Deploy.find_or_create_by!(uid: 'future') do |d|
      d.time        = Deploy::FUTURE
      d.sha         = newest_sha
      d.repository  = repo
      d.username    = nil
      d.environment = 'production'
    end

    return if deploy.sha == newest_sha
    deploy.update_attributes! imported: false, sha: newest_sha
  end

  def newest_sha
    @newest_sha ||= client.branch(repo, 'master').commit.sha
  end
end
