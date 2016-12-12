# delete anything that already exists
Teamdetail.delete_all
User.delete_all 

# create a bunch of data to test with
Teamdetail.create!([{ league_id: "426", team_id: "66", team_name: "Manchester United FC" } ])
Teamdetail.create!([{ league_id: "426", team_id: "57", team_name: "Arsenal FC" } ])
Teamdetail.create!([{ league_id: "426", team_id: "61", team_name: "Chelsea FC" } ])
Teamdetail.create!([{ league_id: "426", team_id: "65", team_name: "Manchester City FC" } ])
Teamdetail.create!([{ league_id: "426", team_id: "64", team_name: "Liverpool FC" } ])
Teamdetail.create!([{ league_id: "426", team_id: "73", team_name: "Tottenham Hotspur FC" } ])
Teamdetail.create!([{ league_id: "430", team_id: "5", team_name: "Bayern Munich" } ])
Teamdetail.create!([{ league_id: "430", team_id: "4", team_name: "Borussia Dotrmund" } ])
Teamdetail.create!([{ league_id: "438", team_id: "109", team_name: "Juventus" } ])
Teamdetail.create!([{ league_id: "438", team_id: "100", team_name: "Roma" } ])
Teamdetail.create!([{ league_id: "438", team_id: "98", team_name: "AC Milan" } ])
Teamdetail.create!([{ league_id: "438", team_id: "113", team_name: "Napoli" } ])
Teamdetail.create!([{ league_id: "436", team_id: "81", team_name: "Barcelona" } ])
Teamdetail.create!([{ league_id: "436", team_id: "86", team_name: "Real Madrid" } ])
Teamdetail.create!([{ league_id: "436", team_id: "78", team_name: "Ateletico Madrid" } ])
#User.create!([{ name: "Daksh", phone_no: "+14122947286", notify_before_match: false, get_live_updates: false  } ])