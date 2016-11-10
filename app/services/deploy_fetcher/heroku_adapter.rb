require 'platform-api'

module DeployFetcher
  class HerokuAdapter
    def initialize(logger)
      require 'platform-api'

      @logger = logger
    end

    def fetch
      @logger.log("Fetching Heroku info", newline: false)
      client.release.list(ENV.fetch('HEROKU_APP')).each do |release|
        next unless release['description'] =~ /^Deploy ([0-9a-f]+)$/
        commit_hash = $1
        slug = client.slug.info(ENV['HEROKU_APP'], release['slug']['id'])

        yield [{
          'created_at'      => release['created_at'],
          'revision'        => commit_hash,
          'repository'      => ENV.fetch('GITHUB_REPO'),
          'local_username'  => release['user']['email'],
          'environment'     => 'production', # DeployImporter expects this
          'artifact_size'   => slug['size'],
        }]
        @logger.log(".", newline: false)
      end
      @logger.log(".")
    end

    private

    def client
      @client ||= PlatformAPI.connect_oauth ENV.fetch('HEROKU_TOKEN')
    end

  end
end
