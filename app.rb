require 'sinatra'
require "active_support/all"
require 'sinatra/activerecord'
require 'json'
require 'rake'

#before do
#	content_type :json
#end

require 'twilio-ruby'
require 'football__data'



enable :sessions

configure :development do
  require 'dotenv'
  Dotenv.load
end
#configuring the gem from 
# GIthub: https://github.com/delta4d/football-data 

FootballData.configure do |config|
    # get api key at 'http://api.football-data.org/register'
    config.api_key = ENV["Footballdata_token"]

    # default api version is 'alpha' if not setted
    config.api_version = 'alpha'

    # the default control method is 'full' if not setted
    # see request section on 'http://api.football-data.org/documentation'
    config.response_control = 'minified'
end


# Checking if they are new users

# Take input of team preference from user

# Take preference of what bot should do every week 
  # Before K.O
    # List fixture 
    # List table rank
    # List time of K.O.
  # Live update from twitter
  # Trending club news

# Modifying preferences 
  # Team
    # Add team
    # Delete team
  # Matchday options for team 

# Stop updates between matches

# Help page




  # get '/incoming_sms' do

  #   session["last_context"] ||= nil
    
  #   sender = params[:From] || ""
  #   body = params[:Body] || ""
  #   body = body.downcase.strip
    
  #   # store a record for each request
  #   log = Log.create( from: sender, messge: body, context: session["last_context"] )
  #   log.save!
      
  #   if check_user_exists( sender )  
      
  #     user = get_user sender 
  #         r.Message "Thanks #{user.first_name}. Just to check, you agree to the terms and conditions and will be ok to get one SMS notification daily?"
  #       end
  #       twiml.text

#if existing user ask them if they want to modify teams, delete/add preferences for selected teams



#code snippets

# # client = Twilio::REST::Client.new ENV["Twilio_sid"], ENV["Twilio_token"]

# # get "/send_sms" do
# #   client.account.messages.create(
# #     :from => "+14122183432",
# #     :to => "+14122947286",
# #     :body => "Hey there, welcome to FootBot. I'm Andy"
# #   )

# #   "Sent message"
# # end

# get '/incoming_sms' do

#   session["counter"] ||= 0
#   count = session["counter"]
  
#   sender = params[:From] || ""
#   body = params[:Body] || ""
#   body = body.downcase.strip

#   link = Reply.where(placeholder: body)
  
#   if link	
#   	message = link.msg  
#   else
#  	message = "Not valid, try who, why, what or where"   
#   end
  
#   session["counter"] += 1
  
#   twiml = Twilio::TwiML::Response.new do |r|
#     r.Message message
#   end

#   content_type 'text/xml'

#   twiml.text
  
# end

# get'/' do
# 	error 401
# end

# error 401 do
# 	{ error: "Not allowed"}.to_json
# end


#  # def check_user_exists from_number
#  #    User.where( phone_number: from_number ).count > 0
#  #  end

#  #  def get_user from_number
#  #    User.where( phone_number: from_number ).first
#  #  end

#  #  def ask_for_registration
  
#  #    session["last_context"] = "ask_for_registration"
  
#  #    twiml = Twilio::TwiML::Response.new do |r|
#  #      r.Message "It doesn't look like you're registered. Would you like to get set up now?"
#  #    end
#  #    twiml.text
  
#  #  end

#  #  def begin_registration sender
  
#  #    session["last_context"] = "begin_registration"
  
#  #    user = User.create( phone_number: sender )
  
#  #    twiml = Twilio::TwiML::Response.new do |r|
#  #      r.Message "Great. I'll get you set up. First, what's your name?"
#  #    end
#  #    twiml.text
  
#   end 