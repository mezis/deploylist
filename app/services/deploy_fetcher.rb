require 'deploy_fetcher/generic'
require 'deploy_fetcher/honeybadger_adapter'

module DeployFetcher
  def self.build(logger)
    adapter = HoneybadgerAdapter.new(logger)
    Generic.new(adapter, logger)
  end
end
