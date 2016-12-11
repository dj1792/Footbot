class UpdateePreferencesTable < ActiveRecord::Migration[5.0]
  def change
  	add_column :preferences, :team, :string
  	remove_column :preferences, :int
  end
end
