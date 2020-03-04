class RemoveAgeFromUser < ActiveRecord::Migration
  def change
    say "WARNING! removing age from user. please run users:set_birth_years BEFORE this migration"
    remove_column :users, :age, :integer
  end
end
