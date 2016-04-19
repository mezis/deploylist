require 'net/http/persistent'

module GithubClient
  private

  def client
    return @client if @client

    stack = Faraday::RackBuilder.new do |builder|
      builder.use Octokit::Middleware::FollowRedirects
      builder.use Octokit::Response::RaiseError
      builder.use Octokit::Response::FeedParser
      builder.adapter :net_http_persistent
    end

    @client = Octokit::Client.new(access_token: ENV.fetch('GITHUB_TOKEN'), middleware: stack)
  end

  def repo
    ENV['GITHUB_REPO']
  end
end
