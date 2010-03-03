class RideMailer < ActionMailer::Base
  
  def extract_emails(persons) 
    #extract email address
    persons.collect! do |p| 
      unless p.email_revoked then p.email else nil end
    end
    persons.compact!
    return persons
  end

  #everyone but joiner
  def join_email(ride, joiner)
    people_to_mail = ride.riders | ride.watchers | [ride.driver]
    people_to_mail.delete(joiner)

    recipients "BeYourOwnBus <notifications@beyourownbus.com>"
    bcc extract_emails(people_to_mail)
    from "BeYourOwnBus <notifications@beyourownbus.com>"
    subject joiner.name + " joined your ride, " + ride.name
    sent_on Time.now
    content_type "text/html"
    body ({:ride => ride, :joiner => joiner})
  end 

  #everyone but driver
  def destroy_email(ride_name, driver, people_to_mail)

    recipients "BeYourOwnBus <notifications@beyourownbus.com>"
    bcc extract_emails(people_to_mail) 
    from "BeYourOwnBus <notifications@beyourownbus.com>"
    subject driver.name + " canceled your ride, " + ride_name
    sent_on Time.now
    content_type "text/html"
    body ({:ride_name => ride_name, :driver => driver})
  end

  #everyone but driver 
  def update_email(ride)
    people_to_mail = ride.riders | ride.watchers 

    recipients "BeYourOwnBus <notifications@beyourownbus.com>"
    bcc extract_emails(people_to_mail) 
    from "BeYourOwnBus <notifications@beyourownbus.com>"
    subject ride.driver.name + " updated your ride, " + ride.name
    sent_on Time.now
    content_type "text/html"
    body ({:ride => ride})
  end

  #everyone else 
  def comment_email(ride, comment)
    people_to_mail = ride.riders | ride.watchers | [ride.driver]
    people_to_mail.delete(comment.user)

    recipients "BeYourOwnBus <notifications@beyourownbus.com>"
    bcc extract_emails(people_to_mail)
    from "BeYourOwnBus <notifications@beyourownbus.com>"
    subject comment.user.name + " commented on your ride, " + ride.name
    sent_on Time.now
    content_type "text/html"
    body ({:ride => ride, :comment => comment })
  end

  # just driver
  def leave_email(ride, leaver)
    people_to_mail = [ride.driver] 

    recipients "BeYourOwnBus <notifications@beyourownbus.com>"
    bcc extract_emails(people_to_mail) 
    from "BeYourOwnBus <notifications@beyourownbus.com>"
    subject leaver.name + " left your ride, " + ride.name
    sent_on Time.now
    content_type "text/html"
    body ({:ride => ride, :leaver => leaver})
  end

  #just kicked person
  def kick_email(ride, kicked_person)
    people_to_mail = [kicked_person] 

    recipients "BeYourOwnBus <notifications@beyourownbus.com>"
    bcc extract_emails(people_to_mail) 
    from "BeYourOwnBus <notifications@beyourownbus.com>"
    subject "You were kicked off the ride, " + ride.name
    sent_on Time.now
    content_type "text/html"
    body ({:ride => ride, :kicked_person => kicked_person})
  end

  #notify driver 
  def watch_email(ride, watcher)
    people_to_mail = [ride.driver] 

    recipients "BeYourOwnBus <notifications@beyourownbus.com>"
    bcc extract_emails(people_to_mail) 
    from "BeYourOwnBus <notifications@beyourownbus.com>"
    subject watcher.name + " is watching your ride, " + ride.name
    sent_on Time.now
    content_type "text/html"
    body ({:ride => ride, :watcher => watcher })
  end
  
  #notify driver 
  def unwatch_email(ride, unwatcher)
    people_to_mail = [ride.driver] 

    recipients "BeYourOwnBus <notifications@beyourownbus.com>"
    bcc extract_emails(people_to_mail) 
    from "BeYourOwnBus <notifications@beyourownbus.com>"
    subject unwatcher.name + " stopped watching your ride, " + ride.name
    sent_on Time.now
    content_type "text/html"
    body ({:ride => ride, :unwatcher => unwatcher })
  end
end
