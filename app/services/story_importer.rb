class StoryImporter
  def initialize(deploy, commit:, pull_request:nil)
    @deploy = deploy
    @commit = commit
    @pull_request = pull_request
  end

  def import

    @deploy.stories.find_or_initialize_by(sha: @commit.sha) do |c|
      c.pull_request_uid  = pull_request_uid
      c.ticket_uid        = ticket_uid
      c.title             = title
      c.message           = message
      c.date              = @commit.commit.author.date
      c.author            = author
      c.save!
    end
  end

  private

  def extractor
    UidExtractor.new [
      @pull_request&.title, @commit.commit.message
    ].compact.join("\n")
  end

  def ticket_uid
    extractor.ticket_uid
  end

  def pull_request_uid
    @pull_request ? @pull_request.number : extractor.pull_request_uid
  end

  def title
    if @pull_request
      TitleCleaner.call @pull_request.title
    else
      head, *_ = commit_entries
      TitleCleaner.call head
    end
  end

  def message
    return @pull_request.body if @pull_request
    _, *tail = commit_entries
    tail.join("\n\n")
  end

  def commit_entries
    @commit.commit.message.split(/\n\n/)
  end

  def author
    email = @commit.commit.author&.email || @commit.commit.committer&.email
    return unless email
    Author.find_or_create_by!(email: email)
  end
end
