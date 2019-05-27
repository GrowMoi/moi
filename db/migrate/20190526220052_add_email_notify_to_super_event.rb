class AddEmailNotifyToSuperEvent < ActiveRecord::Migration
  def change
    add_column :event_achievements, :email_notify, :string
  end
end
