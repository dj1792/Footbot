class UpdatePreferences < ActiveRecord::Migration[5.0]
  def change
  		add_column :preferences, :name, :string
  		add_column :preferences, :team_id, :string
  end
end
