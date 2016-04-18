require 'deploy_fetcher/generic'
require 'deploy_fetcher/honeybadger_adapter'

module DeployFetcher
  def self.build(logger, adapter: nil)
    adapter ||= ENV.fetch('ADAPTER_FETCH', 'HONEYBADGER')
    klass = case adapter.downcase
            when 'honeybadger' then HoneybadgerAdapter
            else raise ArgumentError, "unknown adapter '#{adapter}'"
            end
    adapter = klass.new(logger)
    Generic.new(adapter, logger)
  end
end
