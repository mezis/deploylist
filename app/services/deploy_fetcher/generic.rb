require 'deploy_importer'

module DeployFetcher
  class Generic
    def initialize(adapter, logger)
      @adapter = adapter
      @logger = logger
    end

    def call
      @adapter.fetch do |data|
        DeployImporter.import(data)
      end
    end
  end
end
