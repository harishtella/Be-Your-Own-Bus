class RidePublisher < Facebooker::Rails::Publisher

  self.header = <<-HEADER
    <div style="margin-bottom: 20px;">
      #{ image_tag('layout/applogo_email.jpg') }
    </div>
  
    HEADER

  self.footer = <<-FOOTER

    <br/>
    <br/>
    <span>
      Thanks for using 
      #{ link_to 'BYOB', root_url }.
    </span>
    FOOTER

  self.join_msg = <<-BODY
    <span style="font-size: 18px;">
      #{ link_to joiner.name, 
      "http://www.facebook.com/profile.php?id=" + 
      joiner.facebook_id.to_s } 
      joined your ride, 
      #{ link_to ride.name, :only_path => false, 
      :controller => 'rides', :action => 'show', :id => ride.id }
    </span>
    BODY

  self.destroy_msg = <<-BODY
    <span style="font-size: 18px;">
      #{ link_to driver.name, 
      "http://www.facebook.com/profile.php?id=" + 
      driver.facebook_id.to_s } 
      canceled your ride, 
      #{ ride_name }
    </span>
    BODY

  #everyone but joiner
  def join_email(fb_sess_user, ride, joiner, people_to_mail)
    send_as :email
    recipients people_to_mail
    from fb_sess_user
    title joiner.name + " joined your ride, " + ride.name
    fbml @header + @join_msg + @footer
  end 

  #everyone but driver
  def destroy_email(fb_sess_user, ride_name, driver, people_to_mail)
    send_as :email
    recipients people_to_mail
    from fb_sess_user
    title driver.name + " canceled your ride, " + ride_name
    fbml @header + @join_msg + @footer
  end

  #everyone but driver 
  def update_email(ride)
    send_as :email
    recipients people_to_mail
    from fb_sess_user
    title ride.driver.name + " updated your ride, " + ride.name
    fbml <<-THEMAIL
      <div style="margin-bottom: 20px;">
        #{ image_tag('layout/applogo_email.jpg') }
      </div>

      <span style="font-size: 18px;">
        #{ link_to driver.name, 
        "http://www.facebook.com/profile.php?id=" + 
        ride.driver.facebook_id.to_s } 
        updated the details of your ride, 
        #{ link_to ride.name, :only_path => false, 
        :controller => 'rides', :action => 'show', :id => ride.id }
      </span>

      <br/>
      <br/>
      <span>
        Thanks for using 
        #{ link_to 'BYOB', :only_path => false, :controller =>'byob', 
        :action => 'index' }.
      </span>
      THEMAIL
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
