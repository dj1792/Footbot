 class User < ActiveRecord::Base
    #validates_presence_of :phone_no
	#validates_presence_of :name 
    #validates_presence_of :notify_before_match
    #validates_presence_of :get_live_updates

    has_many :preferences
end
