class AddsMissingShaToDeploys < ActiveRecord::Migration
  def change
    add_column :deploys, :missing_sha, :boolean, default: false
  end
end
