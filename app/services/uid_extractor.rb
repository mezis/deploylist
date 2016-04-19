class UidExtractor
  def initialize(input)
    @input = input
  end

  def pull_request_uid
    # Merge pull request #1234 ...
    # Squashed message ... (#1234)
    input.scan(/Merge pull request #(\d+)|\(#(\d+)\)$/).flatten.find(&:present?)
  end

  def ticket_uid
    input.scan(uid_regexp).flatten.first
  end

  private

  attr_reader :input

  def uid_regexp
    @@uid_regexp ||= Regexp.new(ENV.fetch('TICKET_UID_REGEXP'))
  end
end
