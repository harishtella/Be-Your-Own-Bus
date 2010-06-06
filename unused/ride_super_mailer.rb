module RideSuperMailer
  def self.get_only_proxied_emails(persons) 
    #extract email address
    persons.collect! do |p| 
      if p.email_revoked 
        nil 
      else
        email_domain = p.email.split('@')[1]
        if email_domain.eql? "proxymail.facebook.com" 
          p.facebook_id
        else 
          nil
        end
      end
    end
    persons.compact!

    return persons
  end

  def self.join_email(fb_sess_user, ride, joiner)
    people_to_mail = ride.riders | ride.watchers | [ride.driver]
    people_to_mail.delete(joiner)
    people_to_mail = get_only_proxied_emails(people_to_mail)

    unless people_to_mail.empty? 
      RidePublisher.deliver_join_email(fb_sess_user, 
      ride, joiner, people_to_mail)
    end
    RideMailer.send_later(:deliver_join_email, ride, joiner)
  end

  def self.destroy_email(fb_sess_user, ride_name, driver, people_to_mail)
    people_to_mail = get_only_proxied_emails(people_to_mail)

    unless people_to_mail.empty? 
      RidePublisher.deliver_join_email(fb_sess_user, 
      ride_name, driver, people_to_mail)
    end
    RideMailer.send_later(:deliver_destroy_email, ride_name, driver,
    people_to_mail)
  end

  def self.update_email(fb_sess_ride, ride)
    people_to_mail = ride.riders | ride.watchers 
    people_to_mail = get_only_proxied_emails(people_to_mail)
  end




end
