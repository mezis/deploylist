class ChangePivotalUidToTicketUid < ActiveRecord::Migration
  def up
    add_column :stories, :ticket_uid, :string
    update %{
      UPDATE stories SET ticket_uid = pivotal_uid
    }
    remove_column :stories, :pivotal_uid
  end
end
