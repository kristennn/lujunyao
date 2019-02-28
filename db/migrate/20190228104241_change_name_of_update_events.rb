class ChangeNameOfUpdateEvents < ActiveRecord::Migration[5.2]
  def change
    rename_column :update_events, :event_id, :stuff_id
  end
end
