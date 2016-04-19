class ImportDeploysJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    FullImport.call(limit: 10)
  end
end
