# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem "ar-extensions", :version => '0.9.2'
  config.action_controller.session_store = :active_record_store

  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'Central Time (US & Canada)'
  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de

  config.after_initialize do 
    ActionView::Base.field_error_proc = Proc.new do |html_tag, instance| 
      if (html_tag.slice(1,5) == "label")
        html_tag
      else 
        if instance.error_message.kind_of?(Array)  
          %(#{html_tag}&nbsp;<span class="validation-error">  
            #{instance.error_message.join(',')}</span>)  
        else  
          %(#{html_tag}&nbsp;<span class="validation-error">  
          #{instance.error_message}</span>)  
        end 
      end
    end 

    # ActionMailer link base url is set in 
    # the files in the environement folder
    ActionMailer::Base.smtp_settings = {  
      :address => 'mail.beyourownbus.com',  
      :port => '26',  
      :user_name => 'notifications@beyourownbus.com',
      :password => 'Youoveeye7',
      :authentication => 'login' #this may not be right
    } 

    class String 
      def to_b
        if self == "true" 
          true
        else
          false
        end
      end
    end
  end
end
