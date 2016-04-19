class FullImport
  def self.call(limit: 100, stream: $stdout)
    @logger = DeployLogger.new(stream)
    @logger.log("Fetching deploy information...")

    DeployFetcher.build(@logger).call

    FutureDeployUpdater.new.call

    @deploys = Deploy.not_imported.production.limit(limit)

    @deploys.each do |deploy|
      @logger.log("Reviewing deploy: #{deploy.sha}")
      previous_deploy = deploy.previous

      next if deploy == previous_deploy
      next unless deploy&.sha && previous_deploy&.sha
      next if deploy.sha == previous_deploy.sha

      CommitFetcher.new(deploy, previous_deploy).call
      deploy.update_attributes! imported: true
    end

    @logger.log(".")
    @logger.log("Done.")
  end
end
