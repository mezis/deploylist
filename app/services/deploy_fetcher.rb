require 'deploy_fetcher/generic'
require 'deploy_fetcher/honeybadger_adapter'
require 'deploy_fetcher/heroku_adapter'

module DeployFetcher
  def self.build(logger, adapter: nil, limit: nil)
    adapter ||= ENV.fetch('ADAPTER_FETCH', 'HONEYBADGER')
    klass = case adapter.downcase
            when 'honeybadger' then HoneybadgerAdapter
            when 'heroku' then HerokuAdapter
            else raise ArgumentError, "unknown adapter '#{adapter}'"
            end
    adapter = klass.new(logger, limit: limit)
    Generic.new(adapter, logger)
  end
end
