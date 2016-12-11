class CreateTeamdetailsTable < ActiveRecord::Migration[5.0]
  def change
  	create_table :teamdetails do |t|
	     t.integer :league_id
	     t.string :team_id
	     t.string :team_name
  end
  end
end
