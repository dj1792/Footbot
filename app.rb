require 'sinatra'
require "active_support/all"
require 'sinatra/activerecord'
require 'json'
require 'rake'

#before do
#	content_type :json
#end

require 'twilio-ruby'
require 'httparty'

enable :sessions

require_relative './models/teamdetail'
require_relative './models/user'
require_relative './models/preference'

configure :development do
  require 'dotenv'
  Dotenv.load
end


# Checking if they are new users

# Take input of team preference from user

# Take preference of what bot should do every week 
  # Before K.O
    # List fixture and KO time
    # List table rank

# Modifying preferences 
  # Team
    # Add team
    # Delete team
  # Matchday options for team 

# Stop updates between matches

# Help page


client = Twilio::REST::Client.new ENV["Twilio_sid"], ENV["Twilio_token"]

get '/incoming_sms' do
    
    session["last_context"] ||= nil

    sender = params[:From] || ""
    body = params[:Body] || ""
    body = body.downcase.strip
    
      
    if check_for_user( sender )  
      
      user = get_user sender 
        if session["last_context"] == "begin_registration"
            user.name = body 
            user.save!
            session["last_context"] = "onboard"     
            twiml = Twilio::TwiML::Response.new do |r|
              r.Message "Great #{user.name}. Lets get your connected with your team eh? (y/n) "
            end
              twiml.text
        elsif session["last_context"] == "onboard" 
            if body.include? "y"
            session["last_context"] = "league" 
            twiml = Twilio::TwiML::Response.new do |r|
              r.Message "Which league lad? \n1.Premier League \n2. Bundesliga \n3. Serie A \n4. Spanish Primera \n (Reply with 1,2,3 or 4)"
            end
              twiml.text     
            else
              error_league
            end
        elsif session["last_context"] == "league" 
              update_league body
        elsif session["last_context"] == "pl" 
              update_preference_pl body  
        elsif session["last_context"] == "bl" 
              update_preference_bl body  
        elsif session["last_context"] == "il" 
              update_preference_il body     
        elsif session["last_context"] == "sl" 
              update_preference_sl body  
        elsif session["last_context"] == "preference" 
              update_user_preference body 
        elsif session["last_context"] == "registered" 
              if session["status"] == "live" and session["choice"] == false
                twiml = Twilio::TwiML::Response.new do |r|
                 r.Message "Hi #{user.name}!! Here's what all you can do...\n 1. View selected preferences\n 2. Add preference\n 3. Get upcoming match updates\n 4.League table\n 5. Trending news\n (Reply with 1,2,3,4 or 5)"
                end
                twiml.text
                session["choice"] == true
              elsif session["status"] == "live" and session["choice"] == true
                user_choice body 
        else
              error_league    
        end
    else 
    # the user isn't registered
        ask_for_registration
        if session["last_context"] == "ask_for_registration" and body.include? "y"
          register sender 
        else
          error_out      
        end
    end
end

get'/' do
  error 401
end

error 401 do
  { error: "Not allowed"}.to_json
end

private

  def check_for_user from_number
      User.where( phone_no: from_number ).count > 0
  end

  def get_user from_number
      User.where( phone_no: from_number ).first
  end

  def ask_for_registration

      session["last_context"] = "ask_for_registration"

      twiml = Twilio::TwiML::Response.new do |r|
        r.Message "Hi I am Andy, welcome to footbot. It seems like you haven't registered. Lets set you up now, shall we? (y/n)"
      end
      twiml.text  
  end
    
  def register sender
      session["last_context"] = "begin_registration"
      
      user = User.create( phone_no: sender )
    
      twiml = Twilio::TwiML::Response.new do |r|
        r.Message "Great. I'll get you set up. First, what's your name?"
      end
      twiml.text 
  end 

  def error_out 
    
      twiml = Twilio::TwiML::Response.new do |r|
        r.Message "Cmon laddie, I need you to register if we're going to chat more"
      end
      twiml.text  
  end

  def error_league 
    
      session["last_context"] = "onboard"     
              twiml = Twilio::TwiML::Response.new do |r|
                r.Message "That was an incorrect response. Lets get your reconnected with your team eh? (y/n) "
              end
                twiml.text
  end 

  def update_league body
      if body.include? "1"
            session["last_context"] = "pl" 
            create_preference
            twiml = Twilio::TwiML::Response.new do |r|
              r.Message "Which team now? \n1.Manchester United \n2. Arsenal \n3. Chelsea \n4. Manchester City \n 5. Liverpool \n6. Tottenham \n(Reply 1,2,3,4,5 or 6)"
            end
            twiml.text
      elsif body.include? "2"
            session["last_context"] = "bl"
            create_preference 
            twiml = Twilio::TwiML::Response.new do |r|
              r.Message "Which team now? \n1.Bayern Munich \n2.Borussia Dortmund \n(Reply with 1 or 2)"
            end
            twiml.text  
      elsif body.include? "3"
            session["last_context"] = "il" 
            create_preference
            twiml = Twilio::TwiML::Response.new do |r|
              r.Message "Which team now? \n1.Juventus \n2.Roma \n3.AC Milan \n4.Napoli \n(Reply with 1,2,3 or 4)"
            end
            twiml.text  
      elsif body.include? "4"
            session["last_context"] = "sl" 
            create_preference
            twiml = Twilio::TwiML::Response.new do |r|
              r.Message "Which team now? \n1.Barcelona \n2.Real Madrid \n3.Ateletico Madrid \n(Reply with 1,2 or 3)"
            end
            twiml.text  
      else
        error_league
      end
  end

    
  def create_preference 
      if session["last_context"] == "pl"
        preference = Preference.create( league_id: "426" )
        preference.name = user.name
        session["preference"] = preference
      elsif session["last_context"] == "bl"
        preference = Preference.create( league_id: "430" )
        preference.name = user.name
        session["preference"] = preference
      elsif session["last_context"] == "il"
        preference = Preference.create( league_id: "438" )
        preference.name = user.name
        session["preference"] = preference
      else session["last_context"] == "sl"
        preference = Preference.create( league_id: "436" )
        preference.name = user.name
        session["preference"] = preference
      end 
  end 

  def update_preference_pl body 
      if body.include? "1" or body.include? "2" or body.include? "3" or body.include? "4" or body.include? "5" or body.include? "6"      
        preference_text 
        if body.include? "1" 
          detail = Teamdetail.where(team_name: "Manchester United" )
          session["preference"].team_id = detail.team_id
          session["preference"].team = "Manchester United"
        elsif body.include? "2" 
          detail = Teamdetail.where(team_name: "Arsenal" )
          session["preference"].team_id = detail.team_id
          session["preference"].team = "Arsenal" 
        elsif body.include? "3" 
          detail = Teamdetail.where(team_name: "Chelsea" )
          session["preference"].team_id = detail.team_id
          session["preference"].team = "Chelsea"
        elsif body.include? "4" 
          detail = Teamdetail.where(team_name: "Manchester City" )
          session["preference"].team_id = detail.team_id 
          session["preference"].team = "Manchester City"          
        elsif body.include? "5" 
          detail = Teamdetail.where(team_name: "Liverpool" )
          session["preference"].team_id = detail.team_id
          session["preference"].team = "Liverpool"
        else body.include? "6" 
          detail = Teamdetail.where(team_name: "Tottenham" )
          session["preference"].team_id = detail.team_id
          session["preference"].team = "Tottenham"
        end  
      else 
        error_league
      end
  end 

  def update_preference_bl body 
      if body.include? "1" or body.include? "2"       
        preference_text 
        if body.include? "1" 
          detail = Teamdetail.where(team_name: "Bayern Munich" )
          session["preference"].team_id = detail.team_id
          session["preference"].team = "Bayern Munich"
        else body.include? "2" 
          detail = Teamdetail.where(team_name: "Borussia Dortmund" )
          session["preference"].team_id = detail.team_id
          session["preference"].team = "Borussia Dortmund"       
        end
      else 
        error_league
      end
  end 

  def update_preference_il body 
      if body.include? "1" or body.include? "2" or body.include? "3" or body.include? "4"       
        preference_text 
        if body.include? "1" 
          detail = Teamdetail.where(team_name: "Juventus" )
          session["preference"].team_id = detail.team_id
          session["preference"].team = "Juventus" 
        elsif body.include? "2" 
          detail = Teamdetail.where(team_name: "Roma" )
          session["preference"].team_id = detail.team_id
          session["preference"].team = "Roma"
        elsif body.include? "3" 
          detail = Teamdetail.where(team_name: "AC Milan" )
          session["preference"].team_id = detail.team_id
          session["preference"].team = "AC Milan"
        else body.include? "4" 
          detail = Teamdetail.where(team_name: "Napoli" )
          session["preference"].team_id = detail.team_id            
          session["preference"].team = "Napoli"
        end
      else 
        error_league
      end
  end 

  def update_preference_sl body 
      if body.include? "1" or body.include? "2" or body.include? "3"      
        preference_text 
        if body.include? "1" 
          detail = Teamdetail.where(team_name: "Barcelona" )
          session["preference"].team_id = detail.team_id
          session["preference"].team = "Barcelona" 
        elsif body.include? "2" 
          detail = Teamdetail.where(team_name: "Real Madrid" )
          session["preference"].team_id = detail.team_id 
          session["preference"].team = "Real Madrid"
        else body.include? "3" 
          detail = Teamdetail.where(team_name: "Ateletico Madrid" )
          session["preference"].team_id = detail.team_id 
          session["preference"].team = "Ateletico Madrid"
        end
      else 
        error_league
      end
  end  

  def preference_text
        session["last_context"] = "preference"
          twiml = Twilio::TwiML::Response.new do |r|
          r.Message "We are now all set with the team. Lets get your update preferences and we should be set.\n 1. Weekly pre-match notifications \n 2. Live twitter updates\n (eg. reply with 1,2 for both) "
        end
        twiml.text
  end

  def update_user_preference body
      if body.include? "1" and body.include? "2" 
        user.notify_before_match = true
        user.get_live_updates = true
        registered_text
      elsif body.include? "1"
        user.notify_before_match = true
        user.get_live_updates = false
        registered_text
      elsif body.include? "2"
        user.notify_before_match = false 
        user.get_live_updates = true
        registered_text
      else 
        preference_text
      end
  end

  def registered_text
        session["last_context"] = "registered"
        session["status"] = "live"
        sesssion["choice"] = false
          twiml = Twilio::TwiML::Response.new do |r|
          r.Message "You're all set laddie!! 1. To add another team reply with more or \n 2. If youre done reply with bye  "
        end
        twiml.text
  end

  def user_choice body 
        if body.include? "1" or body.include? "2" or body.include? "3" or body.include? "4" or body.include? "5" 
          sesssion["choice"] = false
          
          if body.include? "1" 
            user_choice_1

          elsif body.include? "2" 
            user_choice_2

          elsif body.include? "3" 
            user_choice_3

          elsif body.include? "4" 
            user_choice_4
        
          else body.include? "5" 
            #live news
          end
        else 
            error_league
        end               
  end

  def user_choice_1 
      preferences = Preference.where(name: user.name) 
      if preferences.count > 0
          message = "Currently tracking: \n"
          preferences.each do |t|
              message += "#{t.team} \n"
          end
      else
          message = "You're not tracking any team yet."
      end
      twiml = Twilio::TwiML::Response.new do |r|
          r.Message message
      end
            twiml.text  
  end

  def user_choice_2
      session["last_context"] = "onboard"     
      twiml = Twilio::TwiML::Response.new do |r|
        r.Message "Hi #{user.name}. Lets get your connected with your team eh? (y/n) "
      end
      twiml.text
  end


  def user_choice_3

      preferences = Preference.where(name: user.name)
      if preferences.count > 0
            preferences.each do |t|
              team_id = t.team_id
              url = "http://api.football-data.org/v1/teams/#{ team_id.to_s }/fixtures"

              response = HTTParty.get url

              response["fixtures"].each do |item|

                date = item["date"]
                status = item["status"]
                home_team = item["homeTeamName"]
                away_team = item["awayTeamName"]

                puts "Status = #{status}"

                if status == "TIMED"

                  message = "Next match is on #{date}. Home team is #{home_team} playing against #{ away_team }"
                end
              end
            end
      else
          message = "You're not tracking any team yet."
      end
      twiml = Twilio::TwiML::Response.new do |r|
              r.Message message
      end
      twiml.text 
  end

  def user_choice_4

      preferences = Preference.where(name: user.name)
      if preferences.count > 0
          preferences.each do |t|
              competition_id = t.league
              response = HTTParty.get "http://api.football-data.org/v1/competitions/#{competition_id.to_s}/leagueTable"

              message = "Top Five Teams: "

              response["standing"].each do |entry|

                  position = entry["position"]
                  team_name = entry["teamName"]
                  points = entry["points"]

                  if position < 6
                    message += "#{  position }. #{team_name} with #{ points } points. \n"
                  end
              end      
          end
      else
          message = "You're not tracking any team yet."
      end
      twiml = Twilio::TwiML::Response.new do |r|
          r.Message message
      end
      twiml.text 
  end

#code snippets



# # get "/send_sms" do
# #   client.account.messages.create(
# #     :from => "+14122183432",
# #     :to => "+14122947286",
# #     :body => "Hey there, welcome to FootBot. I'm Andy"
# #   )

# #   "Sent message"
# # end


#   content_type 'text/xml'

  
# end



# get '/leaguetable' do 


#   competition_id = 426

#   response = HTTParty.get "http://api.football-data.org/v1/competitions/#{competition_id.to_s}/leagueTable"

#   top_5 = "Top Ten Teams: "

#   response["standing"].each do |entry|

#     position = entry["position"]
#     team_name = entry["teamName"]
#     points = entry["points"]

#     if position < 6
#       top_5 += "#{  position }. #{team_name} with #{ points } points. \n"
#     end

#   end

#   top_5

# end 


# get "/fixtures/:id" do 

#   url = "http://api.football-data.org/v1/teams/#{ params[:id].to_s }/fixtures"

#   response = HTTParty.get url

#   response["fixtures"].each do |item|

#     date = item["date"]
#     status = item["status"]
#     home_team = item["homeTeamName"]
#     away_team = item["awayTeamName"]

#     puts "Status = #{status}"

#     if status == "TIMED"

#       return "Next match is on #{date}. Home team is #{home_team} playing against #{ away_team }"

#     end

#   end

# end 


# get "/twitter/search/:text" do 

#   url = "https://api.twitter.com/1.1/search/tweets.json?q={ params[:text].to_s }"

#   response = HTTParty.get url

#   response.to_json
end
