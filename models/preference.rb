 class Preference < ActiveRecord::Base
	# validates_presence_of :user_id
 #    validates_presence_of :league_id
 #    validates_presence_of :team_name

    has_many :teamdetails
    belongs_to :users
end


