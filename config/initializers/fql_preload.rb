
# this sets up the app's prelaoded fql 

# gets the users email address when they
# visit the homepage

props = {:preload_fql => 
  {:user_info => { 
    :pattern => ".*", 
    :query => "SELECT email, name FROM user WHERE uid={*user*};"
  }}.to_json 
  }
# XXX this causes errors in sometimes in tunnlr and mongrel.
# it doesn't need to be run every time so I'm turning it off for now
# turning back on so it can be run for the real site
Facebooker::Admin.new(Facebooker::Session.create).set_app_properties(props)
