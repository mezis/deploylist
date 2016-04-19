class AddsImportedToDeploys < ActiveRecord::Migration
  def change
    add_column :deploys, :imported, :boolean, default: false
  end
end
