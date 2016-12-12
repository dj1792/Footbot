class Teamdetail < ActiveRecord::Base
	# validates_presence_of :league_id
 #    validates_presence_of :team_id
 #    validates_presence_of :team_name

    belongs_to :preferences
end
