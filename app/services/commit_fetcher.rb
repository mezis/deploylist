class CommitFetcher
  include GithubClient

  def initialize(deploy, previous_deploy)
    @deploy, @previous_deploy = deploy, previous_deploy
  end

  def call
    return if @deploy.missing_sha?

    # commits in the deploy
    commits = comparison.commits.index_by(&:sha)

    # extract pull request merges
    prs = commits.map { |_,c|
      # Github merges look like one of:
      # - "Merge pull request #1234 ..."
      # - "Squashed message ... (#1234)"
      pr_id = UidExtractor.new(c.commit.message).pull_request_uid
      next unless pr_id
      pr = pull_request(pr_id)
      next unless pr
      next unless pr.merge_commit_sha = c.sha
      pr
    }.compact
    
    # all merge commits
    pr_merge_hashes = Set.new prs.map(&:merge_commit_sha)

    # list all "inner" commits from the merged PRs
    pr_commit_hashes = Set.new prs.flat_map { |pr|
      client.compare(repo, pr.base.sha, pr.head.sha).commits.map(&:sha)
      # note that the more obvious code beow
      # tends to exclude head commits from PRs
      #   client.pull_request_commits(repo, pr.number).map(&:sha)
    } 

    # add entries for non-"inner" PR commits from original list
    commits.each do |_,c|
      next if pr_commit_hashes.include? c.sha
      next if pr_merge_hashes.include? c.sha
      StoryImporter.new(deploy, commit: c).import
    end

    # add entries for merged PRs
    prs.each do |pr|
      c = commits[pr.merge_commit_sha]
      StoryImporter.new(deploy, commit: c, pull_request: pr).import
    end
  end

  private

  attr_reader :deploy, :previous_deploy

  def comparison
    @comparison ||= client.compare(repo, previous_deploy.sha, deploy.sha)
  end

  def pull_request(number)
    client.pull_request(repo, number)
  rescue Octokit::NotFound
    nil
  end
end
