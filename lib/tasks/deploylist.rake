namespace :deploylist do

  desc "Perform a full deploy list import"
  task fetch: :environment do
    FullImport.call
  end

  task fetch_async: :environment do
    unless Delayed::Job.exists?
      ImportDeploysJob.perform_later
    end
  end
end
