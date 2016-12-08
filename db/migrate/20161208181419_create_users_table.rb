class CreateUsersTable < ActiveRecord::Migration[5.0]
  
  def change
  	
    create_table :users do |t|
	     t.string :name
	     t.string :phone_no
	     t.boolean :notify_before_match
	     t.boolean :get_live_updates
   
   end    
  end
end

