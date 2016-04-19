require 'uid_extractor'

class TitleCleaner
  def self.call(input)
    ex = UidExtractor.new(input)
    output = input.dup
    output.gsub!(/\[.*\]/, '')
    output.gsub!(ex.pull_request_uid, '') if ex.pull_request_uid
    output.gsub!(ex.ticket_uid, '') if ex.ticket_uid
    output.gsub!(/^\W+/, '')
    output.strip
  end
end
