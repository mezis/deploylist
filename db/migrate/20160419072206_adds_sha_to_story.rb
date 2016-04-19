class AddsShaToStory < ActiveRecord::Migration
  def change
    add_column :stories, :sha, :string
  end
end
