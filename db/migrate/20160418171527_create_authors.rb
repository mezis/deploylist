class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :email
      t.timestamps null: false
    end

    add_column :stories, :author_id, :integer
  end
end
