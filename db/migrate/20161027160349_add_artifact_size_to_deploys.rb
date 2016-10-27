class AddArtifactSizeToDeploys < ActiveRecord::Migration
  def change
    add_column :deploys, :artifact_size, :integer
  end
end
