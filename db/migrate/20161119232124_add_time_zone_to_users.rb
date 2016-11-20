class AddTimeZoneToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :reminder_active, :boolean, default: true
    add_column :users, :reminder_time, :string, default: "12:00"
    add_column :users, :time_zone, :string
  end
end
